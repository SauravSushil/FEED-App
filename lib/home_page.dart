//import 'dart:js';
import 'dart:async';

import 'package:Feed/login_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 194, 193, 191),
      body: Center(
          child: Row(
            children: [
              const Text("Please login again"),
              ElevatedButton(
                child: const Text("Logout"),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
              )
            ],
          )
      ),
    );
  }
}
