import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  //const Mapspage({ Key? key }) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController myController;

  getMarkerData() async {}
  @override
  Widget build(BuildContext context) {
    Set<Marker> getMarker() {
      return <Marker>[
         Marker(
            markerId: MarkerId('NGO'),
            position: LatLng(19.076090, 72.877426),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: 'NGO'))
      ].toSet();
    }

    return Scaffold(
        body: GoogleMap(
      markers: getMarker(),
      mapType: MapType.terrain,
      initialCameraPosition:
          CameraPosition(target: LatLng(19.076090, 72.877426), zoom: 12.0),
      onMapCreated: (GoogleMapController controller) {
        myController = controller;
      },
    ));
  }
}
