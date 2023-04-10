//Things left to do in this page:
// connect to database
// add data entered by the user on this page to the database

import 'package:Feed/Services/notif_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CollectionReference _posts =
      FirebaseFirestore.instance.collection("Posts");

  final TextEditingController _foodTypeController = TextEditingController();
  final TextEditingController _foodAmtController = TextEditingController();
  final TextEditingController _donorController = TextEditingController();
  final TextEditingController _phNumController = TextEditingController();
  final TextEditingController _pTimeController = TextEditingController();
  final TextEditingController _pDateController = TextEditingController();

  static var Address;
  static var Latitude;
  static var Longitude;

  Future<Map<String, double>> getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("Permissions not given");
      LocationPermission asked = await Geolocator.requestPermission();
      return {"Latitude": 0.00, "Longitude": 0.00};
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      Latitude = currentPosition.latitude;
      Longitude = currentPosition.longitude;

      List<Placemark> placemarks =
          await placemarkFromCoordinates(Latitude, Longitude);

      Address = "${placemarks.reversed.last.subLocality}, "
          "${placemarks.reversed.last.locality}, "
          "${placemarks.reversed.last.administrativeArea}";

      return {
        "Latitude": Latitude,
        "Longitude": Longitude,
      };
    }
  }

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
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                          controller: _donorController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(labelText: 'Donor'),
                          keyboardType: TextInputType.name,
                          onChanged: (value) {
                            _formKey.currentState?.validate();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Donor's name";
                            } else if (!RegExp(r'[A-Za-z][A-Za-z0-9_]$')
                                .hasMatch(value)) {
                              return "Please Enter Valid Donor name";
                            }
                          }),
                      TextFormField(
                          controller: _phNumController,
                          decoration:
                              const InputDecoration(labelText: 'Phone Number'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            _formKey.currentState?.validate();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter a Phone Number";
                            } else if (!RegExp(
                                    r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$')
                                .hasMatch(value)) {
                              return "Please Enter a Valid Phone Number";
                            }
                          }),
                      TextFormField(
                          controller: _foodTypeController,
                          textCapitalization: TextCapitalization.words,
                          decoration:
                              const InputDecoration(labelText: 'Food Type'),
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            _formKey.currentState?.validate();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter food type";
                            }
                          }),
                      TextFormField(
                          controller: _foodAmtController,
                          decoration: const InputDecoration(
                            labelText: 'Food Amount(In plates)',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(),
                          onChanged: (value) {
                            _formKey.currentState?.validate();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Food Amount";
                            } else if (!RegExp(
                                    r'^\s*([1-9]|1[0-9]|3[0-9])?\s*$')
                                .hasMatch(value)) {
                              return "Please Enter a Valid food amount";
                            }
                          }),
                      TextFormField(
                          controller: _pTimeController,
                          decoration:
                              const InputDecoration(labelText: 'Pickup Time'),
                          onChanged: (value) {
                            _formKey.currentState?.validate();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter the time";
                            }
                          }),
                      TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        controller: _pDateController,
                        decoration:
                            const InputDecoration(labelText: 'Pickup Date'),
                        onChanged: (value) {
                          _formKey.currentState?.validate();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter the date";
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () => getCurrentPosition(),
                        child: const Text("Location"),
                      ),
                      ElevatedButton(
                        child: const Text('Create'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            NotificationService().showNotification(
                                title: 'Sample title', body: 'It works');
                            final String foodType = _foodTypeController.text;
                            final String donor = _donorController.text;
                            final String pDate = _pDateController.text;
                            final pTime = _pTimeController.text;
                            final String phNum = _phNumController.text;
                            final double? foodAmt =
                                double.tryParse(_foodAmtController.text);
                            if (foodAmt != null) {
                              Map<String, double> location =
                                  await getCurrentPosition();
                              await _posts.add({
                                "Food Type": foodType,
                                "Food Amount": foodAmt,
                                "Donor": donor,
                                "pTime": pTime,
                                "pDate": pDate,
                                "phNum": phNum,
                                "pAddress": Address,
                                "availability": "Yes",
                                "NGO": "None",
                                "dCoordinates": GeoPoint(location['Latitude']!,
                                    location['Longitude']!),
                              });
                              _foodTypeController.text = '';
                              _foodAmtController.text = '';
                              _donorController.text = '';
                              _pDateController.text = '';
                              _pTimeController.text = '';
                              _phNumController.text = '';
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                            }
                          }
                        },
                      )
                    ],
                  )));
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
