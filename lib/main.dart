import 'package:Feed/history_page.dart';
import 'package:Feed/receiver_page.dart';
import 'package:flutter/material.dart';
import 'donations_page.dart';
import 'login_page.dart';
import 'registeration_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_page.dart';
import 'maps.dart';
import 'donatePage.dart';
import 'DonateHome.dart';
<<<<<<< HEAD
import 'admin.dart';
import 'NewHome.dart';
=======
import 'adminNgo.dart';
import 'adminDonor.dart';
>>>>>>> 1ff2897f6ed14192341f4fcba3191dc463db0a83

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
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: "LoginPage",
      routes: {
        "LoginPage": (context) => const LoginPage(),
        "RegistrationPage": (context) => const RegistrationPage(),
        "HomePage": (context) => const HomePage(),
        "DonateHome": (context) => const DonateHome(),
        "DonatePage": (context) => const DonatePage(),
        "ReceiverPage": (context) => const ReceiverPage(),
        "DonationsPage": (context) => const DonationsPage(),
        "MapsPage": (context) => MapsPage(),
<<<<<<< HEAD
        "Adminpage": (context) => Adminpage(),
        "NewHome": (context) => const NewHome(),
=======
        "AdminPage": (context) => Adminngopage(),
        "HistoryPage": (context) => const HistoryPage(),
        "Adminngo": (context) => Adminngopage(),
        "Admindonor": (context) => Admindonorpage()
>>>>>>> 1ff2897f6ed14192341f4fcba3191dc463db0a83
      },
    );
  }
}
