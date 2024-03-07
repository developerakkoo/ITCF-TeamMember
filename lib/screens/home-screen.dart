import 'package:flutter/material.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teammember/screens/create-team-screen.dart';
import 'package:teammember/widgets/drawer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  String userId = '';
  String uid = '';

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("adminId")!;
    uid = prefs.getString("id")!;
    print("userid on home");
    print(userId);
    print(uid);
    setState(() {
      uid = prefs.getString("id")!;
    });
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leadingWidth: 60,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getGreeting(),
              style:
                  TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
            ),
            Text(
              uid.toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              openDrawer();
              // Navigator.push(
              //     context,
              //     PageTransition(
              //         child: CreateTeamScreen(),
              //         type: PageTransitionType.leftToRight));
            },
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/avatar.png"),
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_on_outlined,
                color: Colors.white,
              ))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: OutlineSearchBar(
              backgroundColor: Colors.black,
              onSearchButtonPressed: ((value) => {print(value)}),
              hintStyle: TextStyle(color: Colors.grey),
              hintText: "Search by matches, players, events",
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              borderColor: Colors.grey,
              hideSearchButton: true,
              padding: const EdgeInsets.only(left: 10, right: 10),
            ),
          )
        ],
      ),
    );
  }
}
