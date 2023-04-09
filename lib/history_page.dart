import 'package:syncfusion_flutter_charts/charts.dart';
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

  int _donations = 0;
  int _donationsAccepted = 0;

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
      body: Column(
        children: [
          SfCircularChart(
            series: <CircularSeries>[
              PieSeries<ChartData, String>(
                //The chart data is defined using a list of ChartData objects, which have two properties:
                //a category (either "Water Count" or "Remaining"),
                // and a value (either the amount of water consumed or the
                //remaining amount needed to reach the goal).
                dataSource: <ChartData>[
                  ChartData('Total Donations', _donations),
                  ChartData('Wasted', _donations - _donationsAccepted),
                  //The dataSource property of the PieSeries widget is set to this list of ChartData objects.

                ],
                xValueMapper: (ChartData data, _) => data.category,
                yValueMapper: (ChartData data, _) => data.value,
                // The xValueMapper function maps the category string to the x-axis value, and the yValueMapper
                //function maps the value to the y-axis value. The dataLabelMapper
                // function maps the value to the text that is displayed as the data label on each chart segment.
                dataLabelMapper: (ChartData data, _) =>
                '${((data.value / _donations) * 100).toStringAsFixed(0)}%',
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
            legend: Legend(isVisible: true),
          ),
          StreamBuilder(
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
                      }
                    });
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ]

      ),

    );
  }
}

class ChartData {
  final String category;
  final int value;

  ChartData(this.category, this.value);
}