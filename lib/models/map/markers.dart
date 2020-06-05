import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Markers {
  Set<Marker> markers= {};
  List<LatLng> locations = [];
  List<String> keyList = [];
  Function(int index) onTap;


  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  Future<void> unpack () async {
    keyList = [];
    locations = [];
    await Firestore.instance.collection('markers').document('markers').get().then((DocumentSnapshot snapshot) {
      snapshot.data['markers'].forEach((markerInfo) {
        keyList.add(markerInfo['key']);
        locations.add(LatLng(markerInfo['point'].latitude, markerInfo['point'].longitude));
        print(snapshot.data['point']);
      });
      print(snapshot.data['markers']);
    });
    return await Firestore.instance.collection('infoAboutStory').document('markers').get();
  }

  Future<void> createMarkers () async {
    final Uint8List markerIcon = await _getBytesFromAsset('assets/img/marker-icon.png', 100);
    for (int i = 0; i < keyList.length; i++) {
      markers.add(
          Marker(
            markerId: MarkerId(keyList[i]),
            onTap: () => onTap(i),
            position: locations[i],
            icon: BitmapDescriptor.fromBytes(markerIcon),
          )
      );
    }
    return markerIcon;
  }

}