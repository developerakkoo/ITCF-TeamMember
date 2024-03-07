import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teammember/providers/auth_provider.dart';
import 'package:teammember/screens/home-screen.dart';
import 'package:teammember/screens/otp-screen.dart';
import 'package:teammember/screens/register-screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void saveData(String uid, int number, String adminId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("adminId", adminId);
    await prefs.setString("id", uid);
    await prefs.setInt("number", number);
    Navigator.push(
        context,
        PageTransition(
            child: OtpScreen(), type: PageTransitionType.leftToRight));
  }

  final _formKey = GlobalKey<FormState>();
  String _uid = '';
  late double height, width;
  @override
  Widget build(BuildContext context) {
    var result;
    final authProvider = Provider.of<AuthProvider>(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: authProvider.loading
          ? Center(
              child: LoadingAnimationWidget.bouncingBall(
                  color: Color(0xff5264F9), size: 30),
            )
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          height: 340,
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Indian Tennis Cricket Federation",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Welcome Player!",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your UID';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _uid = newValue!;
                            },
                            decoration: new InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white30, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white30, width: 2.0),
                                ),
                                hintText: 'UID',
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forgot UID?",
                                textAlign: TextAlign.right,
                                style: TextStyle(color: Colors.grey),
                              )),
                        ),
                        MaterialButton(
                          minWidth: 200.0,
                          onPressed: () {
                            print("Pressed");
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              print("UID is $_uid");
                              authProvider
                                  .login(_uid)
                                  .then((value) => {
                                        print(value),
                                        result = json.decode(value.body),
                                        print("VAlue returned is:- "),
                                        print(result),
                                        if (value.statusCode == 200)
                                          {
                                            print("Success"),
                                            print(result['message']),
                                            //Show snakbar

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content:
                                                        Text("Logged In"))),
                                            saveData(result['UID'],
                                                result['PhoneNo'], result['ID'])
                                          }
                                        else if (value.statusCode == 400)
                                          {
                                            print("400 error"),
                                            print(result['message']),

                                            //Show snakbar
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        result['message']))),
                                          }
                                        else
                                          {
                                            print(value.message),
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                        result['message'])))
                                          }
                                      })
                                  .catchError((error) => {print(error)});
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          padding: const EdgeInsets.all(20.0),
                          child: Ink(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color.fromARGB(255, 82, 154, 249),
                                  Color.fromARGB(255, 82, 154, 249),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: Container(
                              constraints: const BoxConstraints(
                                  minWidth: 200.0,
                                  minHeight:
                                      50.0), // min sizes for Material buttons
                              alignment: Alignment.center,
                              child: const Text(
                                'LOGIN',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: RegisterScreen(),
                                      type: PageTransitionType.rightToLeft));
                            },
                            child: const Text(
                              "Don't have an account? Register.",
                              style: TextStyle(color: Colors.grey),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
