import 'package:Feed/aboutUs.dart';
import 'package:Feed/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'Donatepage.dart';
import 'package:Feed/donations_page.dart';

class DonateHome extends StatefulWidget {
  const DonateHome({super.key});

  @override
  State<DonateHome> createState() => _DonateHomeState();
}

class _DonateHomeState extends State<DonateHome> {
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

  Future<void> _delete(String productId) async {
    await _posts.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have successfully deleted a post")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to FEED'),
        backgroundColor: Colors.grey[800],
      ),
      //backgroundColor: Color.fromARGB(255, 207, 207, 207),
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/try3.png"),
              fit: BoxFit.fitHeight),
        ),
        padding: const EdgeInsets.all(120.0),
        child: GridView.count(
          crossAxisCount: 1,
          children: <Widget>[
            //Btn 1
            Card(
              margin: const EdgeInsets.all(8.0),
              color: Colors.deepPurpleAccent,
              child: InkWell(
                onTap: () => _create(),
                splashColor: Colors.grey,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(
                        Icons.local_hospital_sharp,
                        size: 40,
                      ),
                      Text(
                        'Donate',
                        style: TextStyle(fontSize: 40),
                      )
                    ],
                  ),
                ),
              ),
            ),

            //Btn 2
            Card(
              margin: const EdgeInsets.all(8.0),
              color: Colors.deepPurpleAccent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DonationsPage(),
                      ));
                },
                splashColor: Colors.grey,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(
                        Icons.history_sharp,
                        size: 40,
                      ),
                      Text(
                        'History',
                        style: TextStyle(fontSize: 40),
                      )
                    ],
                  ),
                ),
              ),
            ),

            //Btn 3
            Card(
              margin: const EdgeInsets.all(8.0),
              color: Colors.deepPurpleAccent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const aboutUsPage(),
                      ));
                },
                splashColor: Colors.grey,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(
                        Icons.info_outline_rounded,
                        size: 40,
                      ),
                      Text(
                        'About Us',
                        style: TextStyle(fontSize: 40),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
