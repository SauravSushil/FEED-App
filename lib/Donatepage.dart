//Things left to do in this page:
// connect to database
// add data entered by the user on this page to the database

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Feed/Donatepage.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  // void getCurrentPosition() async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied ||
  //       permission == LocationPermission.deniedForever) {
  //     print("Permissions not given");
  //     LocationPermission asked = await Geolocator.requestPermission();
  //   } else {
  //     Position currentposition = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.best);
  //     print("Latitude: " + currentposition.latitude.toString());
  //     print("Longitude: " + currentposition.longitude.toString());
  //   }

  //   Future<Position> _determinePosition() async {
  //   Future<Position> _determinePosition() async {
  //     bool serviceEnabled;
  //     LocationPermission permission;

  //     // Test if location services are enabled.
  //     serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       // Location services are not enabled don't continue
  //       // accessing the position and request users of the
  //       // App to enable the location services.
  //       return Future.error('Location services are disabled.');
  //     }

  //     permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         // Permissions are denied, next time you could try
  //         // requesting permissions again (this is also where
  //         // Android's shouldShowRequestPermissionRationale
  //         // returned true. According to Android guidelines
  //         // your App should show an explanatory UI now.
  //         return Future.error('Location permissions are denied');
  //       }
  //     }

  //     if (permission == LocationPermission.deniedForever) {
  //       // Permissions are denied forever, handle appropriately.
  //       return Future.error(
  //           'Location permissions are permanently denied, we cannot request permissions.');
  //     }

  //     // When we reach here, permissions are granted and we can
  //     // continue accessing the position of the device.
  //     return await Geolocator.getCurrentPosition();
  //   }
  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  Future<Map<String, String>> getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("Permissions not given");
      LocationPermission asked = await Geolocator.requestPermission();
      return {"Latitude": "", "Longitude": ""};
    } else {
      Position currentposition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      print("Latitude: " + currentposition.latitude.toString());
      print("Longitude: " + currentposition.longitude.toString());
      return {
        "Latitude": currentposition.latitude.toString(),
        "Longitude": currentposition.longitude.toString()
      };
    }
  }

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
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    getCurrentPosition();
                  },
                  child: Text("Location"),
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    final String foodType = _foodTypeController.text;
                    final String pLocation = _pLocationController.text;
                    final String pDate = _pDateController.text;
                    final String pTime = _pTimeController.text;
                    final String phNum = _phNumController.text;
                    final double? foodAmt =
                        double.tryParse(_foodAmtController.text);
                    if (foodAmt != null) {
                      Map<String, String> location = await getCurrentPosition();
                      await _posts.add({
                        "Food Type": foodType,
                        "Food Amount": foodAmt,
                        "Longitude": location['Longitude'],
                        "Latitude": location["Latitude"]
                      });

                      _foodTypeController.text = '';
                      _foodAmtController.text = '';
                      _pLocationController.text = '';
                      _pDateController.text = '';
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
        .then((value) => {setState(() => _dateTime = value!)});
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
                              border: InputBorder.none, hintText: 'Food Type'),
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
                            border: InputBorder.none,
                            hintText: 'Pickup Location'),
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
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                              )),
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
