import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class allUsersPage extends StatefulWidget {
  const allUsersPage({Key? key}) : super(key: key);

  @override
  State<allUsersPage> createState() => _allUsersPageState();
}

class _allUsersPageState extends State<allUsersPage> {
  final CollectionReference _users =
  FirebaseFirestore.instance.collection("Users");

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
      body: StreamBuilder(
        stream: _users.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length, //number of rows
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                if(documentSnapshot.get("Roll") == "NGO"){
                  return Card(
                    margin: const EdgeInsets.all(10),
                    shadowColor: const Color(0xff072A6C),
                    child: ListTile(
                      title: Text("Email: ${documentSnapshot["Email"]}"),
                      subtitle: Text("Roll: ${documentSnapshot["Roll"]}"),
                    ),
                  );
                }
                if(documentSnapshot.get("Roll") == "Donor"){
                  return Card(
                    margin: const EdgeInsets.all(10),
                    shadowColor: const Color(0xff072A6C),
                    child: ListTile(
                      title: Text("Email: ${documentSnapshot["Email"]}"),
                      subtitle: Text("Roll: ${documentSnapshot["Roll"]}"),
                    ),
                  );
                }
                return null;
              }
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
    );
  }

}