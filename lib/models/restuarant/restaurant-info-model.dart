import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com/models/document-id.dart';
import 'package:com/models/restuarant/places-model.dart';
import 'package:com/models/restuarant/rating-model.dart';
import 'package:com/models/restuarant/when-open-model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantInfo {
  String key;
  String title;
  String placeAddress;
  Places places;
  WhenOpen whenOpen;
  Rating rating;
  String cost;
  LatLng geoPoint;
  bool get hasData => key != null;

  Future<void> unpack (DocumentId id) async {
    await Firestore.instance.collection('restaurantInfo').document(id.curId).get().then((snapshot) {
      key = snapshot['id'];
      geoPoint = id.location;
      cost = snapshot['cost'];
      rating = Rating(
        stars: snapshot['raiting']['stars'],
        votedPeople: snapshot['raiting']['votedPeople']
      );

      placeAddress = snapshot['placeAddress'];

      places = Places(
        all: snapshot['places']['all'],
        available: snapshot['places']['available'],
      );

      title = snapshot['title'];

      whenOpen = WhenOpen(
        from: snapshot['whenOpen']['from'],
        to: snapshot['whenOpen']['to'],
      );
    });
    return await Firestore.instance.collection('restaurantInfo').document(id.curId).get();
  }
  void clear () {
    title = null;
    placeAddress = null;
    places = null;
    whenOpen = null;
    rating = null;
    key = null;
  }
}