import 'package:firebase_auth/firebase_auth.dart';
import 'package:Feed/login_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class dlog extends StatefulWidget {
  const dlog({Key? key}) : super(key: key);

  @override
  State<dlog> createState() => _dlogState();
}

class _dlogState extends State<dlog> {
  final user = FirebaseAuth.instance.currentUser?.email;
  final CollectionReference _posts =
      FirebaseFirestore.instance.collection("Posts");

  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "MapsPage");
        },
        elevation: 10.0,
        child: const Icon(Icons.map),
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
                  if (documentSnapshot.get("availability") == "Yes") {
                    return Card(
                        margin: const EdgeInsets.all(10),
                        shadowColor: Color.fromARGB(255, 140, 172, 231),
                        //color: Colors.white,
                        child: ExpansionTile(
                          title: Text(documentSnapshot["Food Type"]),
                          subtitle: Text(
                              "Plates: ${documentSnapshot["Food Amount"].toString()}"),
                          expandedAlignment: Alignment.centerLeft,
                          childrenPadding:
                              const EdgeInsets.fromLTRB(15, 0, 15, 20),
                          //backgroundColor: Colors.grey[300],
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
                  } else if (documentSnapshot.get("availability") == "No" &&
                      documentSnapshot.get("NGO") == user) {
                    return Card(
                        margin: const EdgeInsets.all(10),
                        color: Colors.greenAccent,
                        child: ExpansionTile(
                          title: Text(documentSnapshot["Food Type"]),
                          subtitle: Text(
                              "Plates: ${documentSnapshot["Food Amount"].toString()}"),
                          expandedAlignment: Alignment.centerLeft,
                          childrenPadding:
                              const EdgeInsets.fromLTRB(15, 0, 15, 20),
                          backgroundColor: Colors.greenAccent,
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
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                });
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
    // Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
    //   child: Container(
    //     padding: const EdgeInsets.all(15),
    //     decoration: BoxDecoration(
    //         color: Colors.deepPurple, borderRadius: BorderRadius.circular(10)),
    //     child: Center(
    //       child: TextButton(
    //         onPressed: () {},
    //         child: Text(
    //           'LOGIN',
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    // FloatingActionButton(
    //   elevation: 10.0,
    //   child: const Text(
    //     'About Us',
    //     style: TextStyle(fontSize: 28),

    //     // action on button press
    //   ),
    //   onPressed: () {
    //     // action on button press
    //   },
    // );
  }
}
