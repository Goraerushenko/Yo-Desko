import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantMap extends StatefulWidget {
  @override
  _RestaurantMapState createState() => _RestaurantMapState();
}

class _RestaurantMapState extends State<RestaurantMap> {

  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(37.43296265331129, -122.08832357078792),
            tilt: 59.440717697143555,
            zoom: 19.151926040649414
        ),
        onMapCreated: _onMapCreated,
        mapType: MapType.normal,
      ),
    );
  }
}
