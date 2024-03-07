import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teammember/models/bulk_player_modal.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../models/player_modal.dart';
import '../providers/player_provider.dart';
import 'add-player-to-team-screen.dart';

class AddPlayerInBulk extends StatefulWidget {
  const AddPlayerInBulk({super.key});

  @override
  State<AddPlayerInBulk> createState() => _AddPlayerInBulkState();
}

class _AddPlayerInBulkState extends State<AddPlayerInBulk> {
  final _razorpay = Razorpay();
  String teamAdminId = '';
  String teamId = '';
  late bool _isPayforWholeTeam;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  void _addPlayer(BuildContext context) {
    final String fullName = _fullNameController.text;
    final String phoneNumber = _phoneNumberController.text;

    if (fullName.isNotEmpty && phoneNumber.isNotEmpty) {
      final PlayerModal player = PlayerModal(fullName, phoneNumber, '', true);
      final PlayerProvider playerList =
          Provider.of<PlayerProvider>(context, listen: false);
      playerList.addPlayer(player);

      _fullNameController.clear();
      _phoneNumberController.clear();
    }
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    teamAdminId = prefs.getString("adminId")!;
    teamId = prefs.getString("teamId")!;
    _isPayforWholeTeam = prefs.getBool("isPayforWholeTeam")!;
    print(teamAdminId);
    print(teamId);
    print(_isPayforWholeTeam);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    var nameCtrl = TextEditingController();
    var numberCtrl = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    List<Map<String, dynamic>> items = [];
    var result;
    String phonenumber = '';
    final playerProvider = Provider.of<PlayerProvider>(context);
    final players = playerProvider.playersbulk;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                if (players.length > 14) {
                  return;
                }
                playerProvider.addPlayerBulk(
                    PlayerModalBulk(name: "", number: "", url: ""));
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
        leading: InkWell(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    child: AddPlayerToTeam(),
                    type: PageTransitionType.topToBottom));
          },
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Add Player In Bulk",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: playerProvider.loading
          ? Center(
              child: LoadingAnimationWidget.bouncingBall(
                  color: Color(0xff5264F9), size: 30),
            )
          : players.length != 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Consumer<PlayerProvider>(
                        builder: ((context, value, child) => Expanded(
                              child: ListView.builder(
                                  itemCount: players.length,
                                  itemBuilder: ((context, index) {
                                    final TextEditingController nameController =
                                        TextEditingController();
                                    final TextEditingController
                                        numberController =
                                        TextEditingController();
                                    final TextEditingController urlController =
                                        TextEditingController();
                                    return Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                                width: 1.0,
                                                color: Colors.black),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                      controller:
                                                          nameController,
                                                      onChanged: (value) {
                                                        players[index].name =
                                                            value;
                                                      },
                                                      decoration: InputDecoration(
                                                          labelText:
                                                              'Full Name',
                                                          labelStyle: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                    TextFormField(
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                      controller:
                                                          numberController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged: (value) {
                                                        players[index].number =
                                                            value;
                                                      },
                                                      decoration: InputDecoration(
                                                          labelText:
                                                              'Mobile Number',
                                                          labelStyle: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                    SizedBox(height: 16),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })),
                            ))),
                    MaterialButton(
                      minWidth: 200.0,
                      onPressed: () {
                        print("Pressed");
                        var amount = players.length * 300;
                        var options = {
                          'key': 'rzp_test_NZPT7cTtpJaWr2',
                          'amount': amount * 100,
                          'name': 'Pivot Technosports Private Limited.',
                          'description': 'Fees',
                          // 'prefill': {
                          //   'contact': '8888888888',
                          //   'email': 'test@razorpay.com'
                          // }
                        };
                        _razorpay.open(options);

                        _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                            (PaymentSuccessResponse response) {
                          _razorpay.clear();
                          for (PlayerModalBulk player in players) {
                            items.add({
                              "Name": player.name,
                              "Phone": player.number,
                              "AdminID": teamAdminId,
                            });

                            print(items);
                            playerProvider.AddBulkPlayers(
                                    teamId, teamAdminId, items)
                                .then((value) => {
                                      result = json.decode(value.body),
                                      print("VAlue returned is:- "),
                                      print(result),
                                      if (value.statusCode == 200)
                                        {
                                          print("Success"),
                                          print(result['message']),
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.green,
                                                  content:
                                                      Text(result['message'])))
                                        }
                                    });
                          }
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      padding: const EdgeInsets.all(20.0),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xff5264F9),
                              Color(0xff1433FF)
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(
                              minWidth: 230.0,
                              minHeight:
                                  50.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: const Text(
                            'Add All Players',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : Center(
                  child: Text(
                    "Minimum 15 and Maximum 22 players can be added",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
    );
  }
}

void _handlePaymentSuccess(PaymentSuccessResponse response) {
  // Do something when payment succeeds
  print("Payment Success");
  print(response.orderId);
  print(response.paymentId);
  print(response.signature);
}

void _handlePaymentError(PaymentFailureResponse response) {
  // Do something when payment fails
  print("Payment failed");

  print(response.code);
  print(response.error);
  print(response.message);
}

void _handleExternalWallet(ExternalWalletResponse response) {
  // Do something when an external wallet was selected
  print(response.walletName);
}
