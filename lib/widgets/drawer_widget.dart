import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:page_transition/page_transition.dart';
import 'package:teammember/screens/create-team-screen.dart';
import 'package:teammember/screens/professional_player_register_screen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerState();
}

class _DrawerState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.black,
        child: Material(
          color: Colors.black,
          child: ListView(children: [
            DrawerHeader(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    child: Image.asset(
                  'assets/images/logo.png',
                )),
              ],
            )),
            SizedBox(
              height: 30,
            ),
            ListTile(
              leading: Icon(
                IconlyBroken.home,
                color: Colors.white,
              ),
              title: Text(
                "Home",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                IconlyBroken.user3,
                color: Colors.white,
              ),
              title: Text("Teams", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                    context,
                    PageTransition(
                        child: CreateTeamScreen(),
                        type: PageTransitionType.leftToRight));
              },
            ),
            // ListTile(
            //   leading: Icon(IconlyBroken.star),
            //   title: Text("Professional Player"),
            //   onTap: () {
            //     Navigator.pop(context);

            //     Navigator.push(
            //         context,
            //         PageTransition(
            //             child: ProfessionalPlayerRegisterScreen(),
            //             type: PageTransitionType.leftToRight));
            //   },
            // )
          ]),
        ));
  }
}
