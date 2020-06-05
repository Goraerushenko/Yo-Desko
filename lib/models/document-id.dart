import 'package:google_maps_flutter/google_maps_flutter.dart';

class DocumentId {
  String curId;
  String prevId;
  LatLng location;
  void replaceId (String key, LatLng geoPoint) {
    if (curId != key) {
      prevId = curId;
      curId = key;
      location = geoPoint;
    }
  }
  bool get hasData => curId != null;

  void clear () {
    curId = null;
    prevId = null;
  }

}