import 'package:Feed/login_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReceiverPage extends StatefulWidget {
  const ReceiverPage({Key? key}) : super(key: key);

  @override
  State<ReceiverPage> createState() => _ReceiverPageState();
}

class _ReceiverPageState extends State<ReceiverPage> {
  final CollectionReference _posts =
      FirebaseFirestore.instance.collection("Posts");

  String txtAddress = "";

  Address() async {
    final DocumentSnapshot<Object?> data = await _posts.doc(_posts.id).get();
    var LatLong = data.get("DonorLocation");
    List<Placemark> placemarks =
        await placemarkFromCoordinates(52.2165157, 6.9437819);
    //txtAddress = "${placemarks.reversed.last.locality}, ${placemarks.reversed.last.administrativeArea}, ${placemarks.reversed.last.country}";
    txtAddress = "${placemarks.reversed.last.country}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
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
        child: Icon(Icons.map),
        onPressed: () {
          Navigator.pushNamed(context, "MapsPage");
        },
        elevation: 10.0,
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
                          "Plates: ${documentSnapshot["Food Amount"].toString()}"),
                      expandedAlignment: Alignment.centerLeft,
                      childrenPadding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
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
                            Text("Phone Number: ${documentSnapshot["phNum"]}",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 0.5,
                                  color: Colors.black,
                                )),
                            Text("Pickup Time: ${documentSnapshot["pTime"]}",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                  color: Colors.black,
                                )),
                            Text("Pickup Date: ${documentSnapshot["pDate"]}",
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
                        )
                      ],
                    ));
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // ElevatedButton(
      //   onPressed: () {},
      //   child: Text("Location"),
      // ),
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
