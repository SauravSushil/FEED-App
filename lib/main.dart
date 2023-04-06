import 'package:Feed/receiver_page.dart';
import 'package:flutter/material.dart';
import 'donations_page.dart';
import 'login_page.dart';
import 'registeration_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_page.dart';
import 'maps.dart';
import 'Donatepage.dart';
import 'DonateHome.dart';
import 'admin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  runApp(const FEED());
}

class FEED extends StatelessWidget {
  const FEED({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: "LoginPage",
      routes: {
        "LoginPage": (context) => const LoginPage(),
        "RegistrationPage": (context) => const RegistrationPage(),
        "HomePage": (context) => const HomePage(),
        "DonateHome": (context) => const DonateHome(),
        "Donatepage": (context) => const DonatePage(),
        "ReceiverPage": (context) => const ReceiverPage(),
        "DonationsPage": (context) => const DonationsPage(),
        "MapsPage": (context) => MapsPage(),
        "Adminpage": (context) => Adminpage()
      },
    );
  }
}
