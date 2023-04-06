import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Adminpage extends StatefulWidget {
  @override
  _AdminpageState createState() => _AdminpageState();
}

class _AdminpageState extends State<Adminpage> {
  late GoogleMapController mapController;
  List<Marker> markers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: Set<Marker>.of(markers),
        initialCameraPosition: CameraPosition(
          target: LatLng(19.076090, 72.877426),
          zoom: 9,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Posts').get();
    await FirebaseFirestore.instance.collection('Users').get();

    snapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        GeoPoint? geoPoint = data['dCoordinates'] as GeoPoint?;
        if (geoPoint?.latitude != null && geoPoint?.longitude != null) {
          double latitude = geoPoint!.latitude;
          double longitude = geoPoint.longitude;
          Marker marker = Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(title: data['Donor'] ?? ''),
          );
          markers.add(marker);
        }
      }
      GeoPoint? geoPoint = data!['rCoordinates'] as GeoPoint?;
      if (geoPoint?.latitude != null && geoPoint?.longitude != null) {
        double latitude = geoPoint!.latitude;
        double longitude = geoPoint.longitude;
        Marker marker = Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(title: data['Donor'] ?? ''),
        );
        markers.add(marker);
      }
    });

    setState(() {});
  }
}
