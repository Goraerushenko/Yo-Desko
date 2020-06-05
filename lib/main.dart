import 'package:com/pages/restaurant-map-page.dart';
import 'package:flutter/material.dart';
void main() => runApp(
  MaterialApp (
    home: MyApp(),
  )
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RestaurantsPage();
  }
}
