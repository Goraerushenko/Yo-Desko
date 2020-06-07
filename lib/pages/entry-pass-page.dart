import 'package:com/icons/custom_icons_icons.dart';
import 'package:com/models/document-id.dart';
import 'package:com/models/map/map-utils.dart';
import 'package:com/models/map/markers.dart';
import 'package:com/models/restuarant/restaurant-info-model.dart';
import 'package:com/pages/make-a-booking-page.dart';
import 'package:com/widgets/restaurant_info/current-image-line.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EntryPassPage extends StatefulWidget {
  EntryPassPage (
    {
      Key key,
      this.markers
    }
  ) : super (key: key);

  final Markers markers;
  @override
  _EntryPassPageState createState() => _EntryPassPageState();
}

class _EntryPassPageState extends State<EntryPassPage> {
  List<BookInfo> _bookings = [];
  PageController pageController = PageController(
    initialPage: 0,

  );
  RestaurantInfo _info = RestaurantInfo ();
  DocumentId _id = DocumentId();

  @override
  void initState() {
    List(5).forEach((element) {
      BookInfo info= BookInfo ();
      _id.replaceId(widget.markers.keyList[0], widget.markers.locations[0]);
      info.setDate(DateTime.now());
      _bookings.add(info);
    });

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange[400],
        body: Stack(
          children: <Widget>[
            FutureBuilder(
              future: _info.unpack(_id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _bookings.forEach((element) {
                    element.context = context;
                    element.setStartTime(TimeOfDay.now());
                    element.setEndTime(TimeOfDay.now());
                    element.info = _info;
                  });
                  return _booking ();
                } else {
                  return Center(
                    child: JumpingDotsProgressIndicator(
                      color: Colors.black,
                      fontSize: 50.0,
                    ),
                  );
                }

              },
            ),
            _closeBtn()
          ],
        )
    );
  }

  Widget _booking () => PageView(
    scrollDirection: Axis.horizontal,
    controller: pageController,
    children: _bookings.map((e) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .15, top: MediaQuery.of(context).size.height * .15),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * .15,
          ),
          InkWell(
            onTap: () => MapUtils.openMap(e.info.geoPoint.latitude, e.info.geoPoint.longitude),
            child: Container(
              height: 400,
              width: MediaQuery.of(context).size.width * .7,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3.0,
                      spreadRadius: 1.0,
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                    )
                  ]
              ),
              child: Column(
                children: <Widget>[
                  QrImage (
                    data: '12313123',
                    padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                    size: MediaQuery.of(context).size.width * .6,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Center(
                      child: Text (
                        e.info.title,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0
                        ),
                      ),
                    ),
                  ),
                  _dateContainer (
                    title: e.date,
                    icon: CustomIcons.today
                  ),
                  _dateContainer (
                      title: '${e.startTime} - ${e.endTime}',
                      icon: CustomIcons.access_time
                  ),
                  _dateContainer (
                    child: FutureBuilder(
                      future: e.address.get(e.info.geoPoint),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Flexible(
                            child: Text(
                              e.address.addressLine,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0
                              ),
                            ),
                          );
                        }
                        return JumpingDotsProgressIndicator(
                          color: Colors.black,
                          fontSize: 25.0,
                        );
                      },
                    ),
                    onTap: () {},
                    icon: FontAwesome.location
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )).toList(),
  );

  Widget _dateContainer ({String title, IconData icon, Function onTap, Widget child}) => Padding (
    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(icon, color: Colors.orange, size: 20.0,),
        child == null ? Text(
          title,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14.0
          ),
        ) : child,
        Icon(Icons.chevron_right, color: onTap != null ?  Colors.orange : Colors.transparent,)
      ],

    ),
  );

  Widget _closeBtn () => Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: FloatingActionButton(
        onPressed: () => Navigator.of(context).pop(),
        heroTag: 'close',
        backgroundColor: Colors.black54,
        child: Icon(Icons.close, color: Colors.white,),
      ),
    ),
  );
}
