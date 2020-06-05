import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address {
  String addressLine;
  LatLng geoPoint;
  Future<void> get (LatLng point) async {
    final coordinates = new Coordinates(point.latitude, point.longitude);
    final addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    geoPoint = point;
    print(addresses.first.addressLine.split(','));
    List<String> list = addresses.first.addressLine.split(',');
    addressLine = '${list[0]}, ${list[1]}';
    return await Geocoder.local.findAddressesFromCoordinates(coordinates);
  }
}