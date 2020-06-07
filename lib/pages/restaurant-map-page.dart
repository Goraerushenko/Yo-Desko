import 'package:com/icons/custom_icons_icons.dart';
import 'package:com/models/map/markers.dart';
import 'package:com/pages/entry-pass-page.dart';
import 'package:com/widgets/map.dart';
import 'package:com/widgets/preview-restaurant-info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'profile-page.dart';
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
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, bottom: MediaQuery.of(context).size.height * .1),
                child: Row(
                  children: <Widget>[
                    _profile (),
                    _settings (),
                    _booking ()
                  ],
                ),
              ),
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

  Widget _settings () => FloatingActionButton(
    onPressed: () {},
    heroTag: 'settingPage',
    mini: true,
    backgroundColor: Colors.white,
    child: Center (
      child: Icon(
        Icons.settings,
        color: Colors.black,
      ),
    ),
  );

  Widget _booking () => FloatingActionButton(
    onPressed: () => Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => EntryPassPage (markers: _markers,)
        )
    ),
    heroTag: 'booking',
    mini: true,
    backgroundColor: Colors.white,
    child: Center (
      child: Icon(
        FontAwesome.ticket,
        color: Colors.black,
      ),
    ),
  );

  Widget _profile () => FloatingActionButton (
    heroTag: 'profilePage',
    mini: true,
    backgroundColor: Colors.white,
    child: Center (
      child: Icon (
        CustomIcons.user,
        color: Colors.black,
      ),
    ),
    onPressed: () => Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ProfilePage (markers: _markers,)
      )
    ),
  );

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
