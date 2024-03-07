import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teammember/providers/auth_provider.dart';
import 'package:teammember/providers/player_provider.dart';
import 'package:teammember/providers/team_provider.dart';
import 'package:teammember/screens/Login-screen.dart';
import 'package:teammember/screens/Spalsh-Screen.dart';
import 'package:teammember/screens/add-player-to-team-screen.dart';
import 'package:teammember/screens/add-player-via-phone-number.dart';
import 'package:teammember/screens/add-via-link-screen.dart';
import 'package:teammember/screens/add_player_bulk_screen.dart';
import 'package:teammember/screens/add_player_contacts.dart';
import 'package:teammember/screens/create-team-screen.dart';
import 'package:teammember/screens/home-screen.dart';
import 'package:teammember/screens/otp-screen.dart';
import 'package:teammember/screens/professional_player_register_screen.dart';
import 'package:teammember/screens/razorpay_screen.dart';
import 'package:teammember/screens/register-screen.dart';
import 'package:teammember/test/player_add.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider(),
          ),
          ChangeNotifierProvider(create: (_) => PlayerProvider()),
          ChangeNotifierProvider(create: (_) => TeamProvider())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Team Member',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/': ((context) => LoginScreen()),
            '/login': ((context) => LoginScreen()),
            '/register': ((context) => RegisterScreen()),
            '/otp': ((context) => OtpScreen()),
            '/home': ((context) => HomeScreen()),
            '/add-link': ((context) => AddViaLinkScreen()),
            '/add-phone': ((context) => AddPlayerViaPhoneNumber()),
            '/add-team': ((context) => AddPlayerToTeam()),
            '/create-team': ((context) => CreateTeamScreen()),
            '/add-contact': (context) => AddPlayerFromContacts(),
            '/add-bulk': (context) => AddPlayerInBulk(),
            '/professional-player': (context) =>
                ProfessionalPlayerRegisterScreen(),
            '/razorpay': (context) => RazorpayScreen()
          },
        ));
  }
}
