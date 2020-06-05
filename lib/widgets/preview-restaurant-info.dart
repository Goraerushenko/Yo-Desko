import 'package:com/models/document-id.dart';
import 'package:com/models/map/markers.dart';
import 'package:com/models/restuarant/restaurant-info-model.dart';
import 'package:com/pages/full-restaurant-info-page.dart';
import 'package:com/widgets/stars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class PreviewRestaurantInfo extends StatefulWidget {
  PreviewRestaurantInfo({
    Key key,
    @required this.padding,
    @required this.screenSize,
    @required this.markers
  }): super(key: key);

  final Size screenSize;
  final Markers markers;
  final EdgeInsets padding;

  @override
  _PreviewRestaurantInfoState createState() => _PreviewRestaurantInfoState();
}

class _PreviewRestaurantInfoState extends State<PreviewRestaurantInfo> with TickerProviderStateMixin{

  Animation _slidePreviewPanelAnim;

  final RestaurantInfo _restaurantInfo = RestaurantInfo();

  AnimationController _slidePreviewPanelCont;

  DocumentId _id = DocumentId();

  double _opacity = 0.0;

  @override
  void initState() {
    _slidePreviewPanelCont = AnimationController (vsync: this, duration: Duration (milliseconds: 500));
    _slidePreviewPanelAnim = Tween(
        begin: -widget.screenSize.height * 0.3,
        end: widget.padding.top + 10
    ).animate(_slidePreviewPanelCont)..addListener(() => setState(() {
      if (_slidePreviewPanelCont.status == AnimationStatus.dismissed) {
        _restaurantInfo.clear();
        _id.clear();
      } else if (_slidePreviewPanelCont.status == AnimationStatus.reverse) {
        _opacity = 0.0;
      }
    }));

    widget.markers.onTap = (int index) {
      if (!_slidePreviewPanelCont.isAnimating && _slidePreviewPanelCont.status == AnimationStatus.completed && _id.curId != widget.markers.keyList[index]) {
        _slidePreviewPanelCont.reverse();
        Future.delayed(Duration(milliseconds: 500), () {
          _restaurantInfo.clear();
          _id.clear();
          _slidePreviewPanelCont.forward();
          _opacity = 1.0;
          _id.replaceId(widget.markers.keyList[index], widget.markers.locations[index]);
        });
      } else if (!_slidePreviewPanelCont.isAnimating){
        _slidePreviewPanelCont.forward();
        _opacity = 1.0;
        _id.replaceId(widget.markers.keyList[index], widget.markers.locations[index]);
      }
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(MediaQuery.of(context).size.width * 0.05, _slidePreviewPanelAnim.value),
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: Duration(milliseconds: 500),
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => FullRestaurantInfoPage (
                    restaurantInfo: _restaurantInfo,
                  )
              )
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 20.0,
                      color: Colors.grey,
                      spreadRadius: 1.0
                  )
                ]
            ),
            child: Stack(
              children: <Widget>[
                _restaurantInfo.hasData ?
                  _previewContainer () :
                  !_id.hasData ?
                    SizedBox() :
                    FutureBuilder(
                      future: _restaurantInfo.unpack(_id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return _previewContainer ();
                        } else return Center(
                          child: JumpingDotsProgressIndicator(
                            fontSize: 50.0,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => _slidePreviewPanelCont.reverse(),
                        child: Container(
                          height: IconTheme.of(context).size,
                          width:  IconTheme.of(context).size,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: Center(
                            child:  Icon(Icons.close, color: Colors.white,) ,
                          ),
                        ),
                      ),
                    )

              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _previewContainer () => Column (
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        height: (MediaQuery.of(context).size.height * 0.25) / 2 * 1.2,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
          image: DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80'),
            fit: BoxFit.cover
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0, right: 14.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${_restaurantInfo.title}',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  height: IconTheme.of(context).size + 5,
                  width:  IconTheme.of(context).size + 20,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Center(
                    child:  Text(_restaurantInfo.cost, style: TextStyle(color: Colors.white, fontSize: 16.0),),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      Container (
        height: (MediaQuery.of(context).size.height * 0.25) / 2 * 0.8,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stars(
                    _restaurantInfo.rating,
                    size: 14.0,
                  ),
                  Text(
                    'Open today ${_restaurantInfo.whenOpen.from} to ${_restaurantInfo.whenOpen.to}',
                    style: TextStyle(
                        color: Colors.teal[400]
                    ),
                  ),
                  Text(
                    '${_restaurantInfo.places.available}/${_restaurantInfo.places.all} Seats Open',
                    style: TextStyle(
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => FullRestaurantInfoPage (
                          restaurantInfo: _restaurantInfo,
                        )
                    )
                ),
                child: Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  child: Center(
                      child: Text (
                        'View',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0
                        ),
                      )
                  ),
                ),
              )
            ],
          ),
        ),
      ),


    ],
  );
}
