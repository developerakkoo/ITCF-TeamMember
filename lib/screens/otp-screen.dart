import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teammember/screens/home-screen.dart';

import '../providers/auth_provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  late String number;
  late String code;
  String userId = '';

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    number = prefs.getInt("number").toString();
    print(number);
    sendOtp();
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isMobileVerified", true);
    Navigator.push(
        context,
        PageTransition(
            child: HomeScreen(), type: PageTransitionType.bottomToTop));
  }

  void sendOtp() {
    var result;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    authProvider
        .sendOtp(number)
        .then((value) => {
              print("OTP is"),
              print(value),
              result = json.decode(value.body),
              print("VAlue returned is:- "),
              print(result),
              if (value.statusCode == 200)
                {
                  print("userid is $result['postObj']['UserID']"),
                  userId = result['postObj']['UserID']
                }
            })
        .catchError(((err) => {print(err)}));
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color.fromRGBO(30, 60, 87, 1);
    OtpFieldController otpController = OtpFieldController();
    var result;
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   leading: const Icon(
      //     Icons.arrow_back_ios_rounded,
      //     color: Colors.black,
      //   ),
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   centerTitle: true,
      //   title: const Text(
      //     "Add Player via Phone Number",
      //     style: TextStyle(color: Colors.black),
      //   ),
      // ),
      body: authProvider.loading
          ? Center(
              child: LoadingAnimationWidget.bouncingBall(
                  color: Color(0xff5264F9), size: 30),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 90,
                    ),
                    Image.asset("assets/images/otp.png"),
                    SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "OTP Verification",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Enter OTP sent to +918007477149",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    OTPTextField(
                      controller: otpController,
                      length: 4,
                      otpFieldStyle: OtpFieldStyle(
                          errorBorderColor: Colors.red,
                          backgroundColor: Colors.white70,
                          enabledBorderColor: Colors.white,
                          borderColor: Colors.white,
                          focusBorderColor: Colors.white),
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: 45,
                      style: TextStyle(fontSize: 17, color: Colors.white),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.box,
                      onChanged: (pin) {
                        print("Changed: " + pin);
                        code = pin;
                      },
                      onCompleted: (pin) {
                        print("Completed: " + pin);
                        code = pin;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Didn't you receive the OTP?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        debugPrint('Hi there');
                        // authProvider.verifyOtp(number, code).then((value) => {
                        //       result = json.decode(value.body),
                        //       print("VAlue returned is:- "),
                        //       print(result),
                        //       if (value.statusCode == 200) {saveData()}
                        //     });
                        Navigator.push(
                            context,
                            PageTransition(
                                child: HomeScreen(),
                                type: PageTransitionType.fade));
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
                          child: const Text(
                            'Verify',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
