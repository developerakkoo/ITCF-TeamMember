import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teammember/models/player_modal.dart';
import 'package:teammember/providers/player_provider.dart';
import 'package:teammember/screens/add-player-to-team-screen.dart';

import '../widgets/add-player-widget.dart';

class AddPlayerViaPhoneNumber extends StatefulWidget {
  const AddPlayerViaPhoneNumber({super.key});

  @override
  State<AddPlayerViaPhoneNumber> createState() =>
      _AddPlayerViaPhoneNumberState();
}

class _AddPlayerViaPhoneNumberState extends State<AddPlayerViaPhoneNumber> {
  String teamAdminId = '';
  String teamId = '';
  String name = '';
  String number = '';

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    teamAdminId = prefs.getString("adminId")!;
    teamId = prefs.getString("teamId")!;
    print(teamAdminId);
    print(teamId);
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var result;
    var nameCtrl = TextEditingController();
    var numberCtrl = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    String name = '';
    String number = '';
    final playerProvider = Provider.of<PlayerProvider>(context);

    final players = playerProvider.players;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            playerProvider.clearPlayerList();
            Navigator.push(
                context,
                PageTransition(
                    child: AddPlayerToTeam(),
                    type: PageTransitionType.topToBottom));
          },
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Add Player via Phone Number",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: playerProvider.loading
          ? Center(
              child: LoadingAnimationWidget.bouncingBall(
                  color: Color(0xff5264F9), size: 30),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter phone number';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                print("number $value");
                                number = value!;
                              });
                            },
                            style: TextStyle(height: 1.6, color: Colors.white),
                            decoration: const InputDecoration(
                                filled: false,
                                fillColor: Color(0xffE9F7FE),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white70, width: 2.0),
                                ),
                                hintText: 'Add Phone Number',
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              if (players.length == 1) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Only One Player can be added at once.")));
                                return;
                              }
                              playerProvider
                                  .addPlayer(PlayerModal("", number, "", true));
                            }
                          },
                          child: Container(
                            height: 65,
                            width: 70,
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              gradient: LinearGradient(colors: [
                                Color.fromARGB(255, 82, 154, 249),
                                Color.fromARGB(255, 82, 154, 249),
                              ]),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Consumer<PlayerProvider>(
                    builder: ((context, playerProvider, child) => Expanded(
                          child: ListView.builder(
                              itemCount: playerProvider.players.length,
                              itemBuilder: ((context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                            width: 1.0, color: Colors.black),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 50,
                                              backgroundImage: AssetImage(
                                                  'assets/images/avatar.png'),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  controller: nameCtrl,
                                                  onChanged: (value) {
                                                    name = value;
                                                  },
                                                  decoration: InputDecoration(
                                                      labelText: 'Full Name',
                                                      labelStyle: TextStyle(
                                                          color: Colors.white)),
                                                ),
                                                TextFormField(
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  initialValue: playerProvider
                                                      .playerList[0].number,
                                                  onSaved: (value) {
                                                    number = value!;
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          'Mobile Number',
                                                      labelStyle: TextStyle(
                                                          color: Colors.white)),
                                                ),
                                                SizedBox(height: 16),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      // Add your button click logic here
                                                      playerProvider
                                                          .setValuesAtZeroIndex(
                                                              name,
                                                              playerProvider
                                                                  .playerList[0]
                                                                  .number,
                                                              true);
                                                      print(name);
                                                      print(playerProvider
                                                          .playerList[0]
                                                          .number);

                                                      SelectPaymentType(
                                                          context,
                                                          playerProvider,
                                                          name,
                                                          playerProvider
                                                              .playerList[0]
                                                              .number);
                                                    },
                                                    child: Text(
                                                        'Add as a New Player'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                        )))
              ],
            ),
    );
  }

  PlayerProvider OnlyAddPlayer(PlayerProvider playerProvider) => playerProvider;

  Future<dynamic> SelectPaymentType(BuildContext context,
      PlayerProvider playerProvider, String name, String number) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => Container(
              height: 130,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      print("open Razorpay for payment");
                    },
                    child: ListTile(
                      trailing: Icon(IconlyLight.arrowRight2),
                      leading: Icon(Icons.payment),
                      title: Text("Pay For Player"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      var result;

                      playerProvider.AddSinglePlayers(
                              teamId, teamAdminId, name, number)
                          .then((value) => {
                                print(value),
                                result = json.decode(value.body),
                                print("VAlue returned is:- "),
                                print(result),
                                if (value.statusCode == 201)
                                  {
                                    print("Success"),
                                    playerProvider.clearPlayerList(),
                                    Navigator.pop(context),
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                                "Player Added Successfully!")))
                                  }
                              })
                          .catchError((err) {
                        print(err + "---");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(result['message'])));
                      });
                    },
                    child: ListTile(
                      trailing: Icon(IconlyLight.arrowRight2),
                      leading: Icon(Icons.payment),
                      title: Text("Only create Player"),
                    ),
                  ),
                ],
              ),
            ));
  }
}
