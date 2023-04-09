import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
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
          zoom: 1,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Posts').get();

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
    });

    setState(() {});
  }
}
