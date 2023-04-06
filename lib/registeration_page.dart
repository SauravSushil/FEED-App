import 'dart:async';

//import 'package:feed/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';

import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection("Users");
  final _auth = FirebaseAuth.instance;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController emailController = TextEditingController();
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
      Position currentposition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      Latitude = currentposition.latitude;
      Longitude = currentposition.longitude;

      List<Placemark> placemarks =
          await placemarkFromCoordinates(Latitude, Longitude);
      Address = "${placemarks.reversed.last.subLocality}, "
          "${placemarks.reversed.last.locality}, "
          "${placemarks.reversed.last.administrativeArea}, "
          "${placemarks.reversed.last.country}";
      print("Latitude: $Latitude");
      print("Longitude: $Longitude");
      print("Address: $Address");

      return {
        "Latitude": currentposition.latitude,
        "Longitude": currentposition.longitude,
      };
    }
  }

  void postDetailsToFirestore(
    String email,
    String roll,
  ) async {
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('Users');
    // ref.doc(user!.uid).set({
    ref.doc(user!.uid).set({
      'Email': emailController.text,
      'Roll': roll,
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 194, 193, 191),
        //backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
              Image.asset(
                'assets/images/logoo.png',
                height: 200,
                width: 200,
                scale: 0.5,
              ),
              const SizedBox(height: 5),
              Text(
                'Register',
                style: GoogleFonts.montserrat(
                  fontSize: 40,
                  //fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email ID',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Confirm password',
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text)
                          .then((value) {
                        {
                          postDetailsToFirestore(emailController.text, "Donor");
                        }
                        Navigator.pushNamed(context, "HomePage");
                      });
                    },
                    child: const Text(
                      ' SIGN UP as a DONOR ',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      var user = _auth.currentUser;
                      getCurrentPosition();
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text)
                          .then((value) async {
                        {
                          Map<String, double> location =
                              await getCurrentPosition();
                          await _users.doc(user!.uid).set({
                            "Email": emailController.text,
                            "Roll": "NGO",
                            "rCoordinates": GeoPoint(
                                location['Latitude']!, location['Longitude']!)
                          });
                          //postDetailsToFirestore(emailController.text, "NGO");
                        }
                        Navigator.pushNamed(context, "HomePage");
                      });
                      // Map<String, double> location = await getCurrentPosition();
                    },
                    child: const Text(
                      ' SIGN UP as a NGO ',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     TextButton(
              //       onPressed: () {
              //         FirebaseAuth.instance
              //             .createUserWithEmailAndPassword(
              //                 email: emailController.text,
              //                 password: passwordController.text)
              //             .then((value) {
              //           {
              //             postDetailsToFirestore(emailController.text, "Admin");
              //           }
              //           Navigator.pushNamed(context, "Adminpage");
              //         });
              //       },
              //       child: const Text(
              //         ' SIGN UP as a Admin ',
              //         style: TextStyle(
              //           color: Colors.blue,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ],
              // )
            ]))));
  }
}
