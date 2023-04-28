import 'package:Feed/DonateHome.dart';
import 'package:Feed/NewHome.dart';
import 'package:Feed/admin.dart';
import 'package:Feed/AdminNgo.dart';
import 'package:Feed/home_page.dart';
import 'package:Feed/receiver_page.dart';
import 'package:Feed/registeration_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin.dart';
import 'dlog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        .where("Email", isEqualTo: user.email)
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
                builder: (context) => const NewHome(),
              ),
            );
          } else if (item_data["Roll"] == "Admin") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminPage(),
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
        backgroundColor: const Color(0xffFFFCF2),
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/g.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
                child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  //SizedBox(height: 25),
                  //Positioned(
                  //  bottom: 50,
                  //  right: 25,
                  //  child: Image.asset('assets/images/logo.png'),
                  SizedBox(height: 80),

                  Image.asset(
                    'assets/images/logoo.png',
                    height: 200,
                    width: 200,
                    scale: 1.0,
                    //alignment: ,
                  ),
                  SizedBox(height: 50),
                  Text(
                    'WELCOME TO FEED',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      //fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Text(
                  //   'Please Login to continue',
                  //   style: TextStyle(
                  //     //fontWeight: FontWeight.bold,
                  //     fontSize: 24,
                  //   ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Email ID',
                                    ),
                                    onChanged: (value) {
                                      _formKey.currentState?.validate();
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please Enter Username/Email";
                                      } else if (!RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value)) {
                                        return "Please Enter Valid  Username/Email";
                                      }
                                    }),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // password
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: TextFormField(
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Password',
                                    ),
                                    onChanged: (value) {
                                      _formKey.currentState?.validate();
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please Enter Password";
                                      }
                                      //  else if (!RegExp(
                                      //         r'[A-Za-z][A-Za-z0-9_]$')
                                      //     .hasMatch(value)) {
                                      //   return "Please Enter Valid Password";
                                      // }
                                    }),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // sign in
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 170),
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                  color: const Color(0xff072A6C),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: TextButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      User? user = await signIn(
                                          emailController.text,
                                          passwordController.text);
                                      //context: context);
                                      print(user);
                                    }
                                    // User? user = await signIn(
                                    //     emailController.text,
                                    //     passwordController.text);
                                    // //context: context);
                                    // print(user);
                                    // signIn(emailController.text, passwordController.text);
                                  },
                                  child: Text(
                                    'LOGIN',
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Not a registered member ? ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, "RegistrationPage");
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
                        ],
                      ))
                ]))));
  }
}
