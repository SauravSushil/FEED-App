import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';

class DonationsPage extends StatefulWidget {
  const DonationsPage({Key? key}) : super(key: key);

  @override
  _DonationsPageState createState() => _DonationsPageState();
}

class _DonationsPageState extends State<DonationsPage> {
  final CollectionReference _posts =
      FirebaseFirestore.instance.collection("Posts");

  final TextEditingController _foodTypeController = TextEditingController();
  final TextEditingController _foodAmtController = TextEditingController();
  final TextEditingController _donorController = TextEditingController();
  final TextEditingController _phNumController = TextEditingController();
  final TextEditingController _pTimeController = TextEditingController();
  final TextEditingController _pDateController = TextEditingController();
  final TextEditingController _pLocationController = TextEditingController();

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _foodTypeController,
                  decoration: const InputDecoration(labelText: 'Food Type'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _foodAmtController,
                  decoration: const InputDecoration(
                    labelText: 'Food Amount',
                  ),
                ),
                TextField(
                  controller: _donorController,
                  decoration: const InputDecoration(labelText: 'Donor'),
                ),
                TextField(
                  controller: _phNumController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                TextField(
                  controller: _pTimeController,
                  decoration: const InputDecoration(labelText: 'Pickup Time'),
                ),
                TextField(
                  controller: _pLocationController,
                  decoration:
                      const InputDecoration(labelText: 'Pickup Location'),
                ),
                TextField(
                  controller: _pDateController,
                  decoration: const InputDecoration(labelText: 'Drop Location'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  //controller: _pLocationController,
                  onPressed: () {},
                  child: Text("Location"),
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    final String foodType = _foodTypeController.text;
                    final String phNum = _phNumController.text;
                    final String donor = _donorController.text;
                    final String pTime = _pTimeController.text;
                    final String pLocation = _pLocationController.text;
                    final String pDate = _pDateController.text;
                    final double? foodAmt =
                        double.tryParse(_foodAmtController.text);

                    if (foodAmt != null) {
                      await _posts.add({
                        "Food Type": foodType,
                        "Food Amount": foodAmt,
                        "Donor": donor,
                        "pLocation": pLocation,
                        "pDate": pDate,
                        "pTime": pTime,
                        "phNum": phNum,
                      });

                      _foodTypeController.text = '';
                      _foodAmtController.text = '';
                      _pLocationController.text = '';
                      _pDateController.text = '';
                      _pTimeController.text = '';
                      _phNumController.text = '';
                      _donorController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _foodTypeController.text = documentSnapshot["Food Type"];
      _foodAmtController.text = documentSnapshot["Food Amount"].toString();
      _pLocationController.text = documentSnapshot["Pickup Location"];
      _pDateController.text = documentSnapshot["Pickup Date"];
      _pTimeController.text = documentSnapshot["Pickup Time"];
      _phNumController.text = documentSnapshot["Phone Number"];
      _donorController.text = documentSnapshot["Donor"];
      //  _pLocationController.text = documentSnapshot["Location"];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _foodTypeController,
                  decoration: const InputDecoration(labelText: 'Food Type'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _foodAmtController,
                  decoration: const InputDecoration(
                    labelText: 'Food Amount',
                  ),
                ),
                TextField(
                  controller: _donorController,
                  decoration: const InputDecoration(labelText: 'Donor'),
                ),
                TextField(
                  controller: _phNumController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                TextField(
                  controller: _pDateController,
                  decoration: const InputDecoration(labelText: 'Pickup Date'),
                ),
                TextField(
                  controller: _pTimeController,
                  decoration: const InputDecoration(labelText: 'Pickup Time'),
                ),
                TextField(
                  controller: _pLocationController,
                  decoration:
                      const InputDecoration(labelText: 'Pickup Location'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String foodType = _foodTypeController.text;
                    final String pTime = _pTimeController.text;
                    final String phNum = _phNumController.text;
                    final String donor = _donorController.text;
                    final String pLocation = _pLocationController.text;
                    final String pDate = _pDateController.text;
                    final double? foodAmt =
                        double.tryParse(_foodAmtController.text);
                    if (foodAmt != null) {
                      await _posts.doc(documentSnapshot!.id).update({
                        "Food Type": foodType,
                        "Food Amount": foodAmt,
                        "Pickup Location": pLocation,
                        "Pickup Date": pDate,
                        "Pickup Time": pTime,
                        "phNum": phNum,
                        "Donor": donor
                      });

                      _foodTypeController.text = '';
                      _foodAmtController.text = '';
                      _pLocationController.text = '';
                      _pDateController.text = '';
                      _pTimeController.text = '';
                      _phNumController.text = '';
                      _donorController.text = '';

                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _posts.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have successfully deleted a post")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Center(child: Text("FEED")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                            Text("Pickup Date: ${documentSnapshot["pDate"]}",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16,
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
                            Text(
                                "Pickup Location: ${documentSnapshot["pLocation"]}",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 0.5,
                                  color: Colors.black,
                                )),
                            // Text(
                            // " Location: ${documentSnapshot["pLocation"]}",
                            // textAlign: TextAlign.start,
                            // style: const TextStyle(
                            //   fontSize: 15,
                            //   letterSpacing: 0.5,
                            //   color: Colors.black,
                            // )),
                            Row(
                              children: [
                                IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _update(documentSnapshot)),
                                const SizedBox(),
                                IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () =>
                                        _delete(documentSnapshot.id)),
                              ],
                            )
                          ],
                        ),
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
    );
  }
}
