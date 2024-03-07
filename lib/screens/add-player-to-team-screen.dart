import 'dart:convert';
import 'dart:ui';

import 'package:emoji_alert/emoji_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teammember/screens/add-player-via-phone-number.dart';
import 'package:teammember/screens/add-via-link-screen.dart';
import 'package:teammember/screens/add_player_bulk_screen.dart';
import 'package:teammember/screens/create-team-screen.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

import '../providers/player_provider.dart';

class AddPlayerToTeam extends StatefulWidget {
  const AddPlayerToTeam({super.key});

  @override
  State<AddPlayerToTeam> createState() => _AddPlayerToTeamState();
}

class _AddPlayerToTeamState extends State<AddPlayerToTeam> {
  String _teamID = '';
  String _adminId = '';
  late PhoneNumber _selectedContactNumber;
  String _selectedContactName = '';
  _opencontacts() async {
    try {
      final PlayerProvider playerProvider =
          Provider.of<PlayerProvider>(context, listen: false);
      final PhoneContact contact =
          await FlutterContactPicker.pickPhoneContact(askForPermission: true);
      _selectedContactNumber = contact.phoneNumber!;
      _selectedContactName = contact.fullName!;
      print(_selectedContactNumber.number);
      print(_selectedContactName);
      String numericString =
          _selectedContactNumber.number.toString().replaceAll('-', '');
      int numericValue = int.tryParse(numericString)!;
      SelectPaymentType(context, playerProvider, _selectedContactName,
          numericValue.toString());
    } catch (err) {
      print(err);
    }
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _teamID = prefs.getString("teamId")!;
    _adminId = prefs.getString("adminId")!;
    print(_teamID);
    print(_adminId);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

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
                              _teamID, _adminId, name, number)
                          .then((value) => {
                                print(value),
                                result = json.decode(value.body),
                                print("VAlue returned is:- "),
                                print(result),
                                if (value.statusCode == 201)
                                  {
                                    print("Success"),
                                    Navigator.pop(context),
                                    EmojiAlert(
                                        mainButtonText: Text("Okay!"),
                                        onMainButtonPressed: () {
                                          Navigator.pop(context);
                                        },
                                        cancelable: true,
                                        description: Column(
                                          children: [
                                            Text("Player Added!"),
                                            Text(
                                              "Player is Successfully Added in Team.",
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )).displayAlert(context)
                                  }
                              })
                          .catchError((err) {
                        print(err + "---");
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

  @override
  Widget build(BuildContext context) {
    final PlayerProvider playerProvider = Provider.of<PlayerProvider>(context);
    return playerProvider.loading
        ? Center(
            child: LoadingAnimationWidget.bouncingBall(
                color: Color(0xff5264F9), size: 30),
          )
        : Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: CreateTeamScreen(),
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
                "Add Player To Team",
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.black,
                      child: ListTile(
                        onTap: (() {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: AddPlayerViaPhoneNumber(),
                                  type: PageTransitionType.bottomToTop));
                        }),
                        leading: Container(
                            height: 94,
                            width: 94,
                            decoration: const BoxDecoration(
                                color: Color(0xff11263C),
                                shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset("assets/images/phone.png"),
                            )),
                        title: const Text(
                          "Add via Phone Number",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        subtitle: const Text(
                          "Best for adding 1 - 2 players quickly",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: Colors.black,
                      child: ListTile(
                        onTap: (() {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: AddViaLinkScreen(),
                                  type: PageTransitionType.bottomToTop));
                        }),
                        trailing: Container(
                            height: 94,
                            width: 94,
                            decoration: const BoxDecoration(
                                color: Color(0xff11263C),
                                shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset("assets/images/link.png"),
                            )),
                        title: const Text(
                          "Add via Team Link",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        subtitle: const Text(
                          "Fastest way to add all team members",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: Colors.black,
                      child: ListTile(
                        onTap: (() {
                          _opencontacts();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text("This will open contacts of user."),
                          ));
                        }),
                        leading: Container(
                            height: 94,
                            width: 94,
                            decoration: const BoxDecoration(
                                color: Color(0xff11263C),
                                shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset("assets/images/add-user.png"),
                            )),
                        title: const Text(
                          "Add from Contacts",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        subtitle: const Text(
                            style: TextStyle(color: Colors.white70),
                            "Best if players are already in your contact"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: Colors.black,
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 20.0),
                        onTap: (() {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: AddPlayerInBulk(),
                                  type: PageTransitionType.bottomToTop));
                        }),
                        trailing: Container(
                            height: 84,
                            width: 84,
                            margin: const EdgeInsets.all(0.0),
                            padding: const EdgeInsets.all(0.0),
                            decoration: const BoxDecoration(
                                color: Color(0xff11263C),
                                shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset("assets/images/group.png"),
                            )),
                        title: const Text(
                          "Add Players in Bulk",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        subtitle: const Text(
                            style: TextStyle(color: Colors.white70),
                            "Use this when you have player list ready"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
