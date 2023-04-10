import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class aboutUsPage extends StatefulWidget {
  const aboutUsPage({Key? key}) : super(key : key);

  @override
  State<aboutUsPage> createState() => _aboutUsPageState();
}

class _aboutUsPageState extends State<aboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffFFFCF2),
        appBar: AppBar(
          backgroundColor: const Color(0xff04724D),
          title: const Center(
              child: Text("FEED")
          ),
        ),

        body: Container(
          child: const Text("FEED is about donating the extra food that would have been thrown out other wise"),
        )
    );
  }


}
