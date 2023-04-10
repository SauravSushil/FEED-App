import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Adminngopage extends StatefulWidget {
  @override
  _AdminngopageState createState() => _AdminngopageState();
}

class _AdminngopageState extends State<Adminngopage> {
  late GoogleMapController mapController;
  List<Marker> markers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Active NGos'),
        backgroundColor: Color(0xff04724D),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreatedngo,
        markers: Set<Marker>.of(markers),
        initialCameraPosition: CameraPosition(
          target: LatLng(19.076090, 72.877426),
          zoom: 9,
        ),
      ),
    );
  }

  // void _onMapCreated(GoogleMapController controller) async {
  //   mapController = controller;
  //   QuerySnapshot snapshot =
  //       await FirebaseFirestore.instance.collection('Posts').get();
  //   //  await FirebaseFirestore.instance.collection('Users').get();

  //   snapshot.docs.forEach((doc) {
  //     Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
  //     if (data != null) {
  //       GeoPoint? geoPoint = data['dCoordinates'] as GeoPoint?;
  //       if (geoPoint?.latitude != null && geoPoint?.longitude != null) {
  //         double latitude = geoPoint!.latitude;
  //         double longitude = geoPoint.longitude;
  //         Marker marker = Marker(
  //           markerId: MarkerId(doc.id),
  //           position: LatLng(latitude, longitude),
  //           infoWindow: InfoWindow(title: data['Donor'] ?? ''),
  //         );
  //         markers.add(marker);
  //       }
  //     }
  //   });

  //   setState(() {});
  // }

  void _onMapCreatedngo(GoogleMapController controller) async {
    mapController = controller;
    QuerySnapshot snapshot =
        // await FirebaseFirestore.instance.collection('Posts').get();
        await FirebaseFirestore.instance.collection('Users').get();

    snapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        GeoPoint? geoPoint = data['rCoordinates'] as GeoPoint?;
        if (geoPoint?.latitude != null && geoPoint?.longitude != null) {
          double latitude = geoPoint!.latitude;
          double longitude = geoPoint.longitude;
          Marker marker = Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(latitude, longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange),
            infoWindow: InfoWindow(title: data['Email'] ?? ''),
          );
          markers.add(marker);
        }
      }
    });

    setState(() {});
  }
}
