import 'package:Feed/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'Donatepage.dart';
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
        title: const Text('Menu'),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[300],
      drawer:  Drawer(
        child: ListView(
          children: const <Widget>[
            ListTile(
              leading: Icon(Icons.account_box_outlined),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.contact_page_outlined),
              title: Text('Contact Us'),
            ),
            ListTile(
              leading: Icon(Icons.mail),
              title: Text('Past Work'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            ListTile(
              leading: Icon(Icons.support_agent_outlined),
              title: Text('Help'),
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('Logout'),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(100.0),
        child: GridView.count(
          crossAxisCount: 1,
          children: <Widget>[
            //Btn 1
            Card(
              margin: const EdgeInsets.all(8.0),
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
                      Text(
                        'Donate',
                        style: TextStyle(fontSize: 30),
                      )
                    ],
                  ),
                ),
              ),
            ),

            //Btn 2
            Card(
              margin: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DonationsPage(),
                      ));
                },
                splashColor: Colors.grey,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Text(
                        'History',
                        style: TextStyle(fontSize: 30),
                      )
                    ],
                  ),
                ),
              ),
            ),

            //Btn 3
            Card(
              margin: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                splashColor: Colors.deepPurpleAccent,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Text(
                        'About Us',
                        style: TextStyle(fontSize: 28),
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
