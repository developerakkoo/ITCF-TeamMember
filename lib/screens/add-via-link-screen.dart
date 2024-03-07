import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teammember/providers/team_provider.dart';
import 'package:teammember/screens/add-player-to-team-screen.dart';

class AddViaLinkScreen extends StatefulWidget {
  const AddViaLinkScreen({super.key});

  @override
  State<AddViaLinkScreen> createState() => _AddViaLinkScreenState();
}

class _AddViaLinkScreenState extends State<AddViaLinkScreen> {
  late String teamId;
  String inviteLinkUrl = '';
  var result;
  Future<dynamic> getTeamById(String id) async {
    try {
      Response res =
          await http.get(Uri.parse("http://35.78.76.21:8000/getById/team/$id"));

      print(res.body);
      if (res.statusCode == 200) {
        print(res.body);

        result = json.decode(res.body);
        print(result['savedteam']);
        setState(() {
          inviteLinkUrl = result['data']['inviteLink'];
        });
        print("Successfull");
        return res as Response;
      } else {
        print("Failure");
        print(res.body);
        return res as Response;
      }

      return res as Response;
    } catch (err) {
      print(err);
    }
  }

  void getTeamId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    teamId = prefs.getString("teamId")!;
    getTeamById(teamId);
  }

  @override
  void initState() {
    super.initState();
    getTeamId();
  }

  @override
  Widget build(BuildContext context) {
    TeamProvider teamProvider =
        Provider.of<TeamProvider>(context, listen: false);
    var result;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => {
            Navigator.push(
                context,
                PageTransition(
                    child: AddPlayerToTeam(),
                    type: PageTransitionType.topToBottom))
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
          "Add Player via Link",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: const Text(
                "Share the link with Players",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 300,
                          height: 160,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black87,
                              border: Border.all(
                                color: Colors.white70,
                                width: 1,
                              )),
                          child: Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              inviteLinkUrl.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            FlutterClipboard.copy(inviteLinkUrl)
                                .then((value) => print('copied'));

                            //                              FlutterClipboard.paste().then((value) {
                            // // Do what ever you want with the value.
                            // setState(() {
                            //   field.text = value;
                            //   pasteValue = value;
                          },
                          child: Container(
                            width: 300,
                            height: 200,
                            child: Align(
                              alignment: Alignment(1, -1),
                              //Alignment(1, -1) place the image at the top & far left.
                              //Alignment (0, 0) is the center of the container
                              //You can change the value of x and y to any number between -1 and 1
                              child: Icon(Icons.copy_all_rounded,
                                  color: Colors.white, size: 37),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )),
            ElevatedButton(
              onPressed: () {
                debugPrint('Hi there');
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(255, 82, 154, 249),
                      Color.fromARGB(255, 82, 154, 249),
                    ]),
                    borderRadius: BorderRadius.circular(13)),
                child: Container(
                  width: 259,
                  height: 50,
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.share),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Share',
                          style: TextStyle(fontSize: 16),
                        ),
                      ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
