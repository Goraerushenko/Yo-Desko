import 'package:com/models/map/markers.dart';
import 'package:com/widgets/map.dart';
import 'package:com/widgets/preview-restaurant-info.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class RestaurantsPage extends StatefulWidget {
  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {

  Markers _markers = Markers();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            FutureBuilder(
              future: _markers.unpack(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return FutureBuilder(
                    future: _markers.createMarkers(),
                    builder: (context, snapshot) =>
                      snapshot.hasData ?
                        RestaurantMap (
                          markers: _markers,
                        ) :
                        _progressIndicator (),
                  );
                } else {
                  return _progressIndicator ();
                }
              },
            ),
            PreviewRestaurantInfo (
              padding: MediaQuery.of(context).padding,
              screenSize: MediaQuery.of(context).size,
              markers: _markers,
            )
          ],
        ),
      ),
    );
  }
  Widget _progressIndicator () => Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    color: Colors.black54,
    child: Center(
      child: JumpingDotsProgressIndicator(
        fontSize: 80.0,
        color: Colors.white,
      ),
    ),
  );
}
