import 'package:com/models/map/address.dart';
import 'package:com/models/map/map-utils.dart';
import 'package:com/models/restuarant/restaurant-info-model.dart';
import 'package:com/pages/make-a-booking-page.dart';
import 'package:com/widgets/route-button.dart';
import 'file:///C:/Users/KINGstong/AndroidStudioProjects/yo_desko/lib/widgets/restaurant_info/anim-app-bar.dart';
import 'file:///C:/Users/KINGstong/AndroidStudioProjects/yo_desko/lib/widgets/restaurant_info/closeBtn.dart';
import 'file:///C:/Users/KINGstong/AndroidStudioProjects/yo_desko/lib/widgets/restaurant_info/current-image-line.dart';
import 'package:com/widgets/stars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../icons/custom_icons_icons.dart';



class FullRestaurantInfoPage extends StatefulWidget {

  FullRestaurantInfoPage ({
    Key key,
    @required this.restaurantInfo,
  }) : super (key: key);
  final RestaurantInfo restaurantInfo;
  @override
  _FullRestaurantInfoPageState createState() => _FullRestaurantInfoPageState();
}

class _FullRestaurantInfoPageState extends State<FullRestaurantInfoPage> with TickerProviderStateMixin{
  ScrollController _listCont = ScrollController();
  CarouselController _controller = CarouselController();

  PageController pageController = PageController(
    viewportFraction: 1.005,
    initialPage: 0,
  );
  AnimationController _viewBtnCont;
  Animation<double> _viewBtnAnim;

  Animation<double> _closeBtnAnim;
  AnimationController _closeBtnCont;

  Address _address = Address();
  @override
  void initState() {
    _closeBtnCont = AnimationController (vsync: this, duration: Duration (milliseconds: 200));
    _closeBtnAnim = Tween(begin: 1.0, end: 0.0).animate(_closeBtnCont);

    _viewBtnCont = AnimationController (vsync: this, duration: Duration (milliseconds: 300));
    _viewBtnAnim = Tween(begin: 0.0, end: 1.0).animate(_viewBtnCont);

    Future.delayed(Duration(milliseconds: 300), () => _viewBtnCont.forward());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SlidingUpPanel(
            parallaxOffset: 0.5,
            parallaxEnabled: true,
            onPanelClosed: () {
              _closeBtnCont.reverse();
            },
            onPanelSlide: (double pos) {
              if (pos > 0) {
                _closeBtnCont.forward();
              }
            },
            maxHeight: MediaQuery.of(context).size.height + 100,
            minHeight: MediaQuery.of(context).size.height * 0.7,
            body: _body(),
            panelBuilder: (ScrollController _controller) {
              _listCont = _controller;
              return ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView (
                  controller: _listCont,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10.0,right: 15.0),
                      child: _restaurantTitle(),
                    ),
                    _restaurantInfo (),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 2.0, right: 10.0),
                      child: _memberPerk (),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 2.0, right: 10.0),
                      child: _checkIn (),
                    ),
                    Container(
                      height: 900,
                    )
                  ],
                ),
              );
            },
          ),
          AnimatedBuilder (
            animation: _closeBtnAnim,
            builder: (context, child) => CloseBtn(
                _closeBtnAnim.value
            ),
          ),
          AnimatedBuilder(
            animation: _listCont,
            builder: (context, child) {
              return Stack(
                children: <Widget>[
                  AnimAppBar(
                    listCont: _listCont,
                    title:  widget.restaurantInfo.title,
                  ),
                ],
              );
            },
          ),
          AnimatedBuilder(
            animation: _viewBtnAnim,
            builder: (context, child) {
              return Align (
                alignment: Alignment.bottomCenter,
                child: RouteBtn (
                  page: MakeBookingPage (
                    address: _address,
                    info: widget.restaurantInfo,
                  ),
                  showAnim: _viewBtnAnim,
                  text: 'Book now',
                  icon: CustomIcons.swatchbook,
                ),
              );
            }
          )
        ],
      )
    );
  }

  Widget _body () => Align(
    alignment: Alignment.topCenter,
    child: Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          CarouselSlider (
            controller: pageController,
            options: CarouselOptions(
              carouselController: _controller,
              height: MediaQuery.of(context).size.height * 0.3,
              enableInfiniteScroll: false,
            ),
            items: ['https://etimg.etb2bimg.com/photo/75161189.cms', 'https://assets.bwbx.io/images/users/iqjWHBFdfxIU/iGk9czFG13tY/v0/1000x-1.jpg', 'https://www.ahstatic.com/photos/5394_rsr001_00_p_1024x768.jpg', 'https://cdn.cnn.com/cnnnext/dam/assets/190710135245-12-waterfront-restaurants.jpg'].map((str) => Image.network(
              str,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              loadingBuilder: (context, child, load) {
                if (load == null) return child;
                return JumpingDotsProgressIndicator(
                  fontSize: 80.0,
                  color: Colors.black,
                );
              },
            ),
            ).toList(),
          ),
          AnimatedBuilder(
            animation: pageController,
            builder: (BuildContext context, child) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: CurrentImageLines(
                    length: 4,
                    curPage: pageController.page,
                  ),
                ),
              );
            }
          ),
        ],
      ),
    ),
  );

  Widget _restaurantInfo () => Container(
    height: 100,
    width: MediaQuery.of(context).size.width * 0.5,
    decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              blurRadius: 3.0,
              spreadRadius: -1.0,
              color: Color.fromRGBO(0, 0, 0, 0.25),
              offset: Offset(0, 5)
          )
        ]
    ),
    child: Padding(
      padding: EdgeInsets.only(left: 15.0, top: 4.0, right: 15.0, bottom: 8.0,),
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Stars (
              widget.restaurantInfo.rating,
              size: 16.0,
            ),
            _placesInfo (),
            _placeAddress (),
          ],
        ),
      ),
    ),
  );

  Widget _checkIn () => Center(
    child: Container(
        height: MediaQuery.of(context).size.height * 0.20,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:  ListTile(
            dense: true,
            title: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text (
                'Check-in',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            subtitle:  Padding(
              padding: EdgeInsets.all(8.0),
              child: Text (
                '1221121234123123412412412412412412414152352314563163463263246',
                softWrap: true,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            leading: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
              ),
              child: Center(
                child: Icon(
                  Icons.person_pin_circle,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        )
    ),
  );

  Widget _memberPerk () => Center(
    child: Container(
      height: MediaQuery.of(context).size.height * 0.20,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          color: Colors.teal[100].withOpacity(.4),
          borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:  ListTile(
          dense: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text (
              'Member Perk',
              style: TextStyle(
                  color: Colors.lightBlueAccent[200].withOpacity(.9),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          subtitle:  Padding(
            padding: EdgeInsets.all(8.0),
            child: Text (
              '1221121234123123412412412412412412414152352314563163463263246',
              softWrap: true,
              style: TextStyle(
                color: Colors.lightBlueAccent[200].withOpacity(.9),
                fontSize: 16.0,
              ),
            ),
          ),
          leading: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlueAccent[200].withOpacity(.9)
            ),
            child: Center(
              child: Icon(
                Icons.lightbulb_outline,
                color: Colors.white,
              ),
            ),
          ),
        ),
      )
    ),
  );
  
  Widget _placeAddress () => FutureBuilder (
    future: _address.get(widget.restaurantInfo.geoPoint),
    builder: (context, snapshot) {
      return snapshot.hasData ? InkWell(
        onTap: () => MapUtils.openMap(widget.restaurantInfo.geoPoint.latitude, widget.restaurantInfo.geoPoint.longitude),
        child: Container(
          child: Row(
            children: <Widget>[
              Icon (
                CustomIcons.direction,
                color: Colors.blueAccent,
                size: 16.0,
              ),
              Text(
                _address.addressLine,
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
              Icon (
                Icons.chevron_right,
                color: Colors.blueAccent,
                size: 16.0,
              ),
            ],
          ),
        ),
      ) : Align(
        alignment: Alignment.centerLeft,
        child: JumpingDotsProgressIndicator(
          color: Colors.black,
          fontSize: 25.0,
        ),
      );
    },
  );

  Widget _placesInfo () => Row(
    children: <Widget>[
      Text (
          'Open',
          style: TextStyle(
            color: Colors.teal[400],
          )
      ),
      SizedBox(
        width: 5,
      ),
      Text(
        '•',
        style: TextStyle(
            color: Colors.grey
        ),
      ),
      SizedBox(
        width: 5,
      ),
      Text(
        '${widget.restaurantInfo.whenOpen.from} to ${widget.restaurantInfo.whenOpen.to}',
        style: TextStyle(
            color: Colors.grey
        ),
      ),
      SizedBox(
        width: 5,
      ),
      Text(
        '•',
        style: TextStyle(
            color: Colors.grey
        ),
      ),
      SizedBox(
        width: 5,
      ),
      RichText(
        text: TextSpan(
            text: '${widget.restaurantInfo.places.available}/${widget.restaurantInfo.places.all} ',
            style: TextStyle(
                color: Colors.black
            ),
            children: [
              TextSpan(
                  text: 'Seats Open',
                  style: TextStyle (
                      color: Colors.grey
                  )
              )
            ]
        ),
      )
    ],
  );

  
  Widget _restaurantTitle () => Text(
    widget.restaurantInfo.title,
    style: TextStyle(
      color: Colors.black,
      fontSize: 26.0,
      fontWeight: FontWeight.bold
    ),
  );
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
