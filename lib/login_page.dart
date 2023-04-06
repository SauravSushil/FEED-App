import 'dart:async';
import 'package:Feed/DonateHome.dart';
import 'package:Feed/admin.dart';
import 'package:Feed/home_page.dart';
import 'package:Feed/receiver_page.dart';
import 'package:Feed/registeration_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  signIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      route();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    print("Test" + user!.uid);
    var test = FirebaseFirestore.instance
        .collection('Users')
        .where("Email", isEqualTo: user!.email)
        .get()
        .then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          var item_data = docSnapshot.data();
          print(item_data["Email"]);
          if (item_data["Roll"] == "Donor") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const DonateHome(),
              ),
            );
          } else if (item_data["Roll"] == "Admin") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Adminpage(),
              ),
            );
          } else if (item_data["Roll"] == "NGO") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ReceiverPage(),
              ),
            );
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    // var kk = FirebaseFirestore.instance
    //     .collection('Users')
    //     .doc(user!.uid)
    //     .get()
    //     .then((DocumentSnapshot documentSnapshot) {
    //   if (documentSnapshot.exists) {
    //       if (documentSnapshot.get("Roll") == "Donor") {
    //         Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => const DonateHome(),
    //           ),
    //         );
    //       } else if (documentSnapshot.get("Roll") == "Admin") {
    //         Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => Adminpage(),
    //           ),
    //         );
    //       } else if (documentSnapshot.get('Roll') == "NGO") {
    //         Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => const ReceiverPage(),
    //           ),
    //         );
    //       }
    //     } else {
    //       print('User does not exist on the database');
    //     }
    //   });
  } 

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 194, 193, 191),
        body: SafeArea(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
              //SizedBox(height: 25),
              //Positioned(
              //  bottom: 50,
              //  right: 25,
              //  child: Image.asset('assets/images/logo.png'),
              Image.asset(
                'assets/images/logoo.png',
                height: 200,
                width: 200,
                scale: 0.5,
              ),
              //SizedBox(height: 25),
              Text(
                'WELCOME TO FEED',
                style: GoogleFonts.montserrat(
                  fontSize: 30,
                  //fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 5),
              // Text(
              //   'Please Login to continue',
              //   style: TextStyle(
              //     //fontWeight: FontWeight.bold,
              //     fontSize: 24,
              //   ),

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
              const SizedBox(height: 33),
              // sign in
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: TextButton(
                      onPressed: () async {
                        User? user = await signIn(
                            emailController.text, passwordController.text);
                        //context: context);
                        print(user);
                        // signIn(emailController.text, passwordController.text);
                      },
                      child: Text(
                        'LOGIN',
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Not a registered member ? ',
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "RegistrationPage");
                    },
                    child: const Text(
                      ' Register Now ',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ]))));
  }
}
