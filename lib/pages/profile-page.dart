import 'package:com/icons/custom_icons_icons.dart';
import 'package:com/models/map/markers.dart';
import 'package:com/pages/entry-pass-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage ({
    Key key,
    this.markers
  }) : super(key: key);
  final Markers markers;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .9),
              child: _bottomNavigationBtns (),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 50, left: 10),
            child: _userInfo (),
          ),
          Align (
            alignment: Alignment.topLeft,
            child: _closeBtn (),
          )
        ],
      ),
    );
  }

  Widget _closeBtn () => Padding(
    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, left: 10),
    child: FloatingActionButton(
      mini: true,
      onPressed: () => Navigator.of(context).pop(),
      heroTag: 'close',
      backgroundColor: Colors.black54,
      child: Icon(Icons.close, color: Colors.white,),
    ),
  );

  Widget _userInfo () => Column(
    children: <Widget>[
      Center(
        child: Container(
          height: MediaQuery.of(context).size.width * .7,
          width: MediaQuery.of(context).size.width * .7,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage('https://dexpertz.net/OnlineBidding/application/css/images/noImage.jpg'),
              fit: BoxFit.contain
            )
          ),
        ),
      ),

      SizedBox (height: 15,),

      Center(
        child: Text(
          'KINGstong',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26.0
          ),
        ),
      )
    ],
  );

  Widget _bottomNavigationBtns () => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      _bottomNavigationBtn (
          title: 'Edit',
          icon: FontAwesome.edit
      ),
      _bottomNavigationBtn (
          title: 'My booking',
          icon: CustomIcons.swatchbook,
        onTap: () => Navigator.push(
            context, CupertinoPageRoute(
            builder: (context) => EntryPassPage(markers: widget.markers,)
          )
        )
      ),
      _bottomNavigationBtn (
          title: 'Logout',
          icon: FontAwesome.logout
      ),
    ],
  );

  Widget  _bottomNavigationBtn ({String title, IconData icon, Function onTap, Color iconColor = Colors.black}) => Column(
    children: <Widget>[
      FloatingActionButton(
        heroTag: title,
        onPressed: onTap,
        backgroundColor: iconColor.withOpacity(.8),
        mini: true,
        child: Icon(
          icon,
          color: Colors.white,),
      ),
      Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold
        ),
      )
    ],
  );
  
}
