import 'package:firebase_auth/firebase_auth.dart';
import 'package:Feed/login_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);


  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final user = FirebaseAuth.instance.currentUser?.email;
  final CollectionReference _posts =
  FirebaseFirestore.instance.collection("Posts");

  //Amount in plates
  int _donations = 4400;
  int _donationsAccepted = 2000;


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffFFFCF2),
      appBar: AppBar(
        backgroundColor: const Color(0xff04724D),
        title: const Center(child: Text("FEED")),
      ),
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
      body: StreamBuilder(
        stream: _posts.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length, //number of rows
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
                  return Card(
                      margin: const EdgeInsets.all(10),
                      child: ExpansionTile(
                        title: Text(documentSnapshot["Food Type"]),
                        subtitle: Text(
                            "Plates: ${documentSnapshot["Food Amount"]
                                .toString()}"),
                        expandedAlignment: Alignment.centerLeft,
                        childrenPadding:
                        const EdgeInsets.fromLTRB(15, 0, 15, 20),
                        backgroundColor: Colors.grey[300],
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Donor: ${documentSnapshot["Donor"]}",
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    letterSpacing: 0.5,
                                    color: Colors.black,
                                  )),
                              Text(
                                  "Phone Number: ${documentSnapshot["phNum"]}",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    letterSpacing: 0.5,
                                    color: Colors.black,
                                  )),
                              Text(
                                  "Pickup Time: ${documentSnapshot["pTime"]}",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                    color: Colors.black,
                                  )),
                              Text(
                                  "Pickup Date: ${documentSnapshot["pDate"]}",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                    color: Colors.black,
                                  )),
                              Text("Address: ${documentSnapshot["pAddress"]}",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    letterSpacing: 0.5,
                                    color: Colors.black,
                                  )),
                            ],
                          ),
                        ],
                      ));
                });
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }
}

class ChartData {
  final String category;
  final int value;

  ChartData(this.category, this.value);
}