import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ReceiverPage extends StatefulWidget {
  const ReceiverPage({Key? key}) : super(key: key);

  @override
  State<ReceiverPage> createState() => _ReceiverPageState();
}

class _ReceiverPageState extends State<ReceiverPage> {
  final user = FirebaseAuth.instance.currentUser?.email;
  final CollectionReference _posts =
      FirebaseFirestore.instance.collection("Posts");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Center(child: Text("FEED")),
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
                            Text(
                                "Pickup Location: ${documentSnapshot["DonorLocation"]}",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 0.5,
                                  color: Colors.black,
                                )),
                            Text(
                                "Address: ${documentSnapshot["pAddress"]}",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 0.5,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () async{
                              await _posts.doc(documentSnapshot!.id).update({
                                "availability": "No",
                                "NGO": user});
                            },
                            child: const Text("Accept"))
                      ],
                    ));}
                else if (documentSnapshot.get("availability") == "No" && documentSnapshot.get("NGO") == user) {
                  return Card(
                      margin: const EdgeInsets.all(10),
                      color: Colors.greenAccent,
                      child: ExpansionTile(
                        title: Text(documentSnapshot["Food Type"]),
                        subtitle: Text(
                            "Plates: ${documentSnapshot["Food Amount"].toString()}"),
                        expandedAlignment: Alignment.centerLeft,
                        childrenPadding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
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
                              Text(
                                  "Address: ${documentSnapshot["pAddress"]}",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    letterSpacing: 0.5,
                                    color: Colors.black,
                                  )),
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () {
                                AlertDialog(
                                    title: const Text('Are you sure?'),
                                    content: const Text('You are about to un-accept the post. Are you sure you want to do that?'),
                                    actions: <Widget>[
                                      SizedBox(
                                        height: 60,
                                        width: 180,
                                        child: Row(
                                            children:[
                                              ElevatedButton(
                                                  child: const Text('Yes'),
                                                  onPressed: () async{
                                                    await _posts.doc(documentSnapshot!.id).update({
                                                      "availability": "Yes",
                                                      "NGO": "None"});
                                                  }),
                                              ElevatedButton(
                                                  child: const Text('No'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  }),
                                            ]
                                        )
                                    )
                                    ]
                                );
                              },
                              child: const Text("Un-Accept Post"))
                        ],
                      ));
                }
                }
                );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
