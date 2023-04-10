import 'package:Feed/aboutUs.dart';
import 'package:Feed/history_page.dart';
import 'package:Feed/login_page.dart';
import 'package:Feed/mStone_page.dart';
import 'package:flutter/material.dart';
import 'donatePage.dart';
import 'package:Feed/donations_page.dart';

class DonateHome extends StatefulWidget {
  const DonateHome({super.key});

  @override
  State<DonateHome> createState() => _DonateHomeState();
}

class _DonateHomeState extends State<DonateHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to FEED'),
        backgroundColor: const Color(0xff04724D),
      ),
      //backgroundColor: Color.fromARGB(255, 207, 207, 207),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Logout'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/try3.png"),
              fit: BoxFit.fitHeight),
        ),
        padding: const EdgeInsets.all(120.0),
        child: GridView.count(
          crossAxisCount: 1,
          children: <Widget>[
            //Btn 1
            Card(
              margin: const EdgeInsets.all(8.0),
              color: Colors.deepPurpleAccent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DonatePage(),
                      ));
                },
                splashColor: Colors.grey,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(
                        Icons.local_hospital_sharp,
                        size: 40,
                      ),
                      Text(
                        'Donate',
                        style: TextStyle(fontSize: 40),
                      )
                    ],
                  ),
                ),
              ),
            ),

            //Btn 2
            Card(
              margin: const EdgeInsets.all(8.0),
              color: Colors.deepPurpleAccent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoryPage(),
                      ));
                },
                splashColor: Colors.grey,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(
                        Icons.history_sharp,
                        size: 40,
                      ),
                      Text(
                        'History',
                        style: TextStyle(fontSize: 40),
                      )
                    ],
                  ),
                ),
              ),
            ),

            //Btn 3
            Card(
              margin: const EdgeInsets.all(8.0),
              color: Colors.deepPurpleAccent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const aboutUsPage(),
                      ));
                },
                splashColor: Colors.grey,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(
                        Icons.info_outline_rounded,
                        size: 40,
                      ),
                      Text(
                        'About Us',
                        style: TextStyle(fontSize: 40),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),

            //Btn 4
            Card(
              margin: const EdgeInsets.all(8.0),
              color: Colors.deepPurpleAccent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MileStonePage(),
                      ));
                },
                splashColor: Colors.grey,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(
                        Icons.history_sharp,
                        size: 40,
                      ),
                      Text(
                        'Milestone',
                        style: TextStyle(fontSize: 40),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
