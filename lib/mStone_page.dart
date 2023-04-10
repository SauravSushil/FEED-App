import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Feed/login_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MileStonePage extends StatefulWidget {
  const MileStonePage({Key? key}) : super(key: key);

  @override
  State<MileStonePage> createState() => _MileStonePageState();
}

class _MileStonePageState extends State<MileStonePage> {
  final CollectionReference _posts =
  FirebaseFirestore.instance.collection("Posts");

  //final int donations = _posts.get("Food Amount");
  //Amount in plates
  int _donations = 4400;
  int _donationsAccepted = 2000;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xffFFFCF2),
      appBar: AppBar(
        backgroundColor: const Color(0xff04724D),
        title: const Center(child: Text("FEED")),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: height/2,
              child: SfCircularChart(
                  series: <CircularSeries>[
                    PieSeries<ChartData, String>(
                      //The chart data is defined using a list of ChartData objects, which have two properties:
                      //a category (either "Water Count" or "Remaining"),
                      // and a value (either the amount of water consumed or the
                      //remaining amount needed to reach the goal).
                      dataSource: <ChartData>[
                        ChartData('Total Donations', _donations),
                        ChartData('Wasted', _donations - _donationsAccepted),
                        //The dataSource property of the PieSeries widget is set to this list of ChartData objects.

                      ],
                      xValueMapper: (ChartData data, _) => data.category,
                      yValueMapper: (ChartData data, _) => data.value,
                      // The xValueMapper function maps the category string to the x-axis value, and the yValueMapper
                      //function maps the value to the y-axis value. The dataLabelMapper
                      // function maps the value to the text that is displayed as the data label on each chart segment.
                      dataLabelMapper: (ChartData data, _) =>
                      '${((data.value / _donations) * 100).toStringAsFixed(0)}%',
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                  legend: Legend(isVisible: true),
                ),
            ),
            // SizedBox(
            //   height: height/2,
            //   child: BlurryContainer(
            //     width: 300.w,
            //     height: 100.h,
            //     blur: 3,
            //     color: Colors.redAccent.withOpacity(0.1),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         // Display the percentage of the total goal completed
            //         Text(
            //           'Today goal : ${_donations.toString()} ',
            //           style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
            //         ),
            //         const SizedBox(height: 10),
            //         Text(
            //           'Donated : ${_donationsAccepted.toString()}',
            //           style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
            //         ),
            //         const SizedBox(height: 10),
            //         // Display the percentage of remaining water
            //         Text(
            //           'Saved : ${((_donations - _donationsAccepted) / _donations * 100).toStringAsFixed(0)}% ',
            //           style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
            //         ),
            //         const SizedBox(height: 10),
            //       ],
            //     ),
            //   ),)
          ]
      ),
    );
  }
}

class ChartData {
  final String category;
  final int value;

  ChartData(this.category, this.value);
}