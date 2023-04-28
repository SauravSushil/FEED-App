import 'package:Feed/history_page.dart';
import 'package:Feed/mStone_page.dart';
import 'package:Feed/receiver_page.dart';
import 'package:flutter/material.dart';
import 'donations_page.dart';
import 'login_page.dart';
import 'registeration_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_page.dart';
import 'maps.dart';
import 'DonateHome.dart';
import 'admin.dart';
import 'NewHome.dart';
import 'AdminNgo.dart' as idk;
import 'adminDonor.dart' as idd;
import 'Adminngo.dart';
import 'admindonor.dart';
import 'dlog.dart';

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
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: "LoginPage",
      routes: {
        "LoginPage": (context) => const LoginPage(),
        "RegistrationPage": (context) => const RegistrationPage(),
        "HomePage": (context) => const HomePage(),
        "DonateHome": (context) => const DonateHome(),
        "ReceiverPage": (context) => const ReceiverPage(),
        "DonationsPage": (context) => const DonationsPage(),
        "MapsPage": (context) => MapsPage(),
        "AdminPage": (context) => const AdminPage(),
        "MilestonePage": (context) => const MileStonePage(),
        "HistoryPage": (context) => const HistoryPage(),
        "Adminngo": (context) => Adminngopage(),
        "Admindonor": (context) => Admindonorpage(),
        "dlog": (context) => const dlog(),
        "NewHome": (context) => const NewHome(),
      },
    );
  }
}
