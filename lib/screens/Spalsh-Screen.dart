import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teammember/screens/Login-screen.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  void loadingTimer() {
    debugPrint("Started Timer");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          "assets/images/Splash.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Column(
                    children: const [
                      Text(
                        "UNLEASH YOUR CRICKET SUPER POWERS WITH US",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 6.0,
                            overflow: TextOverflow.visible,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Easy way to grow your cricket carrer",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 6.0,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      // LinearProgressIndicator(
                      //   value: 1,
                      //   minHeight: 10,
                      //   color: Colors.white,
                      //   backgroundColor: Colors.blue,
                      //   semanticsLabel: 'Linear progress indicator',
                      // ),
                    ],
                  ),
                ),
              ),
              const Text(
                "Version 1.0",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
