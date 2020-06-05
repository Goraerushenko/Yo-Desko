import 'dart:async';
import 'package:com/models/map/markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RestaurantMap extends StatefulWidget {
  RestaurantMap({
    Key key,
    this.markers
  }) : super(key: key);

  final Markers markers;

  @override
  _RestaurantMapState createState() => _RestaurantMapState();
}

class _RestaurantMapState extends State<RestaurantMap> {
  GoogleMapController _controller;

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _myLocation() async {
    final GoogleMapController controller = _controller;
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 17.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[

        GoogleMap(
          onCameraMove: (CameraPosition pos) => print (pos.target),
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(50.45415161181968, 30.51565457135439),
            zoom: 11.0,
          ),
          myLocationEnabled: false,
          tiltGesturesEnabled: false,
          markers: widget.markers.markers,
        ),

        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FloatingActionButton(
              mini: true,
              onPressed: _myLocation,
              child: Center(
                  child: Icon(Icons.my_location, color: Colors.black,),
              ),
              backgroundColor: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
