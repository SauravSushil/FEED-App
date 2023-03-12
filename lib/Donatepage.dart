//Things left to do in this page:
// connect to database
// add data entered by the user on this page to the database

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {

  final CollectionReference _posts =
  FirebaseFirestore.instance.collection("Posts");

  final TextEditingController _foodTypeController = TextEditingController();
  final TextEditingController _foodAmtController = TextEditingController();
  final TextEditingController _pLocationController = TextEditingController();
  final TextEditingController _dLocationController = TextEditingController();
  final TextEditingController _pTimeController = TextEditingController();
  final TextEditingController _phNumController = TextEditingController();

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
                  controller: _pLocationController,
                  decoration: const InputDecoration(labelText: 'Pickup Location'),
                ),
                TextField(
                  controller: _dLocationController,
                  decoration: const InputDecoration(labelText: 'Drop Location'),
                ),
                TextField(
                  controller: _pTimeController,
                  decoration: const InputDecoration(labelText: 'Pickup Time'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    final String foodType = _foodTypeController.text;
                    final String pLocation = _pLocationController.text;
                    final String dLocation = _dLocationController.text;
                    final String pTime = _pTimeController.text;
                    final String phNum = _phNumController.text;
                    final double? foodAmt =
                    double.tryParse(_foodAmtController.text);
                    if (foodAmt != null) {
                      await _posts.add({"Food Type": foodType, "Food Amount": foodAmt});

                      _foodTypeController.text = '';
                      _foodAmtController.text = '';
                      _pLocationController.text = '';
                      _dLocationController.text = '';
                      _pTimeController.text = '';
                      _phNumController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );

        });
  }

  DateTime _dateTime = DateTime.now();
  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2024))
        .then((value) => {
              setState(() => _dateTime = value!)
        }
    );
  }

  int _value = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: Center(
          child: Column(
            children: [
              const SizedBox(height: 25),
              const Text(
                'Donate Now',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Please enter the food details',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              const SizedBox(
                height: 10,
              ),

              //contact info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: TextField(
                        //controller: _phNumController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Contact Number'),
                      ),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),

              //Description of food
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Description of food'),
                        ),
                      ),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),

              //Address
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Your Address'),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Divider(
                color: Colors.black,
                indent: 10,
                endIndent: 10,
              ),

              //Food selection
              const Text(
                'Food Type',
                style: TextStyle(fontSize: 17),
              ),
              Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: _value,
                    onChanged: (value) {
                      setState(() {
                        _value = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  const Text('Veg'),
                ],
              ),

              Row(
                children: [
                  Radio(
                    value: 2,
                    groupValue: _value,
                    onChanged: (value) {
                      setState(() {
                        _value = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  const Text('Non-Veg'),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              const Divider(
                color: Colors.black,
                indent: 10,
                endIndent: 10,
              ),

              // Availability date
              const Text(
                'Available Until',
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(
                height: 15.0,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 115.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10,0,0,0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: Center(
                              child: TextButton(
                                onPressed: _showDatePicker,
                                child: Row(
                                  children: const [
                                    Text(
                                      ' Choose Date ',
                                      style: TextStyle(
                                        color: Colors.deepPurpleAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ),
                        ],
                      ),
                    )),
              ),

              const SizedBox(
                height: 25,
              ),

              //Donate
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: TextButton(
                      onPressed: () => _create(),
                      child: Text(
                        '  Donate ',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )));
  }
}
