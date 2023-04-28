import 'package:Feed/history_page.dart';
import 'package:Feed/mStone_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Feed/aboutUs.dart';
import 'package:Feed/login_page.dart';
import 'package:flutter/material.dart';
import 'package:Feed/donations_page.dart';

import 'Services/notif_service.dart';

class NewHome extends StatefulWidget {
  const NewHome({super.key});

  @override
  State<NewHome> createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  //DateTime date = DateTime(2022, 04, 28);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CollectionReference _posts =
      FirebaseFirestore.instance.collection("Posts");
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _foodTypeController = TextEditingController();
  final TextEditingController _foodAmtController = TextEditingController();
  final TextEditingController _donorController = TextEditingController();
  final TextEditingController _phNumController = TextEditingController();
  final TextEditingController _pTimeController = TextEditingController();
  final TextEditingController _pDateController = TextEditingController();

  static var Address;
  static var Latitude;
  static var Longitude;

  // set selectedDate(DateTime selectedDate) {}

  // Future<Null> _selectDate(BuildContext context) async {
  // final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2015, 8),
  //     lastDate: DateTime(2101));
  // if (picked != null && picked != DateTime.now()) {
  //   setState(() {
  //     selectedDate = picked;
  //   });
  // }
  // }

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
                              return "Please Enter a Food Amount";
                            } else if (!RegExp(
                                    r'^\s*([1-9]|[1-9][0-9]|[1-9][0-9][0-9])?\s*$')
                                .hasMatch(value)) {
                              return "Please Enter a Valid Food Amount";
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
                              return "Please Enter food type";
                            }
                          }),

                      //Text('${date.day}/${date.month}/${date.year}'),
                      // TextFormField(
                      //   // keyboardType: const TextInputType.numberWithOptions(
                      //   //     decimal: true),
                      //   controller: _pDateController,
                      //   decoration:
                      //       const InputDecoration(labelText: 'Pickup Date'),
                      //   onChanged: (value) {
                      //     _formKey.currentState?.validate();
                      //   },
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return "Please Enter the date";
                      //     } else if (!RegExp(
                      //             r'^(0?[1-9]|[12][0-9]|3[01])[\/\-](0?[1-9]|1[012])[\/\-]\d{4}$')
                      //         .hasMatch(value)) {
                      //       return "Please Enter a Valid date in dd/mm/yy format";
                      //     }
                      //   },
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // ElevatedButton(
                      //   onPressed: () => getCurrentPosition(),
                      //   child: const Text("Location"),
                      // ),
                      const SizedBox(height: 20),

                      Padding(
                          padding: const EdgeInsets.only(),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.white10),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextButton(
                              onPressed: _showDatePicker,
                              child: Row(
                                children: const [
                                  Text(
                                    'Choose Pickup Date',
                                    style: TextStyle(
                                      color: Colors.black,
                                      backgroundColor:
                                          Color.fromARGB(255, 214, 213, 213),
                                      fontWeight: FontWeight.bold,
                                      height: 2.8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      TextFormField(
                        readOnly: true,
                        controller: _pDateController,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Pickup Date',
                        ),
                        onTap: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2024),
                          ).then((value) {
                            if (value != null) {
                              _pDateController.text = _dateTime.toString();
                              //DateFormat('yyyy-MM-dd').format(value);
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter date.';
                          }
                          return null;
                        },
                      ),
                      // Text(
                      //   _dateTime.toString(),
                      //   style: const TextStyle(fontSize: 20),
                      // ),
                      ElevatedButton(
                        child: const Text('Create'),
                        onPressed: () async {
                          getCurrentPosition();
                          // DateTime _dateTime = DateTime.now();
                          // void _showDatePicker() {
                          DateTime _dateTime = DateTime.now();
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2023, 04, 27),
                                  lastDate: DateTime(2024))
                              .then((value) =>
                                  {setState(() => _dateTime = value!)});
                          // }

                          // // ignore: unnecessary_null_comparison
                          // if (_dateTime == null) return;

                          // setState(() => date = _dateTime);
                          if (_formKey.currentState!.validate()) {
                            NotificationService().showNotification(
                                title: 'Sample title', body: 'It works');
                            final String foodType = _foodTypeController.text;
                            final String donor = _donorController.text;
                            //final String pDate = _pDateController.text;
                            final pTime = _pTimeController.text;
                            final String phNum = _phNumController.text;
                            final String date = _pDateController.text;
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
                                "pDate": date,
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Welcome '),
          backgroundColor: Color(0xFF04724D),
        ),
        //backgroundColor: Color.fromARGB(255, 207, 207, 207),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('History'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoryPage(),
                      ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Milestones'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MileStonePage(),
                      ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About US'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const aboutUsPage(),
                      ));
                },
              ),
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
            Stack(
              children: [
                Image.asset(
                    'assets/images/lawrence-kayku-ZVKr8wADhpc-unsplash.jpg'),
                Image.asset(
                  'assets/images/1endueanddonate-removebg-preview.png',
                  height: 360,
                  width: size.width,
                  fit: BoxFit.scaleDown,
                ),
                Positioned(
                  bottom: 0.0,
                  child: Container(
                    height: 305.0,
                    width: size.width,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(235, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 330,
                    ),
                    Center(
                      child: Text(
                        'Feed the hungry',
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            shadows: <Shadow>[
                              const Shadow(
                                offset: Offset(3.2, 0.4),
                                blurRadius: 3.0,
                                color: Color.fromARGB(255, 93, 91, 91),
                              ),
                            ]),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Text(
                      'Sharing food, spreading love - make a difference with our donation app! Using FEED, we can make a positive impact on society by reducing food waste and helping those in need',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        //22
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
        floatingActionButton: Theme(
          data: Theme.of(context).copyWith(
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
            extendedSizeConstraints:
                BoxConstraints.tightFor(height: 60, width: 370),
            //420
          )),
          child: FloatingActionButton.extended(
            backgroundColor: const Color(0xFF072A6C),
            label: const Text("DONATE"),
            icon: const Icon(Icons.card_giftcard),
            onPressed: () => _create(),
          ),
        ));
  }
}
