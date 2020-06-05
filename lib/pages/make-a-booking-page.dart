import 'package:com/icons/custom_icons_icons.dart';
import 'package:com/models/document-id.dart';
import 'package:com/models/map/address.dart';
import 'package:com/models/map/map-utils.dart';
import 'package:com/models/restuarant/restaurant-info-model.dart';
import 'package:com/widgets/restaurant_info/anim-app-bar.dart';
import 'package:com/widgets/restaurant_info/closeBtn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class MakeBookingPage extends StatefulWidget {
  MakeBookingPage ({
    Key key,
    @required this.id,
    @required this.info,
    @required this.address,
  }) : super (key: key);

  final DocumentId id;
  final RestaurantInfo info;
  final Address address;
  @override
  _MakeBookingPageState createState() => _MakeBookingPageState();
}

class _MakeBookingPageState extends State<MakeBookingPage> with TickerProviderStateMixin {

  AnimationController _bottomBtnCont;
  Animation<Color> _bottomBtnAnim;

  Animation<double> _routeAnim;
  AnimationController _routeCont;

  BookInfo bookInfo = BookInfo();

  Widget _dateTheme (child) => Theme(
    data: ThemeData.light().copyWith(
      colorScheme: ColorScheme.light(
        primary: Colors.orange,
        onPrimary: Colors.white,
        surface: Colors.orange,
        onSurface: Colors.black,
      ),
      backgroundColor: Colors.orange,

      dialogBackgroundColor:Colors.white,
    ),
    child: child,
  );
  Widget _timeTheme (child) => Theme(
    data: ThemeData.light().copyWith(
      colorScheme: ColorScheme.light(
        primary: Colors.orange,
        onPrimary: Colors.white,
        surface: Colors.orange,
        onSurface: Colors.black,
      ),
      backgroundColor: Colors.grey[50],
      dialogBackgroundColor:Colors.white,
    ),
    child: child,
  );

  @override
  void initState() {
    _bottomBtnCont = AnimationController (vsync: this, duration: Duration(milliseconds: 1000));
    _bottomBtnAnim = ColorTween(begin: Colors.orange[200], end: Colors.orange).animate(_bottomBtnCont);
    _routeCont = AnimationController (vsync: this, duration: Duration(milliseconds: 500));
    _routeAnim = Tween(begin: 0.0, end: 1.0).animate(_routeCont);
    Future.delayed(Duration (milliseconds: 200), () => _routeCont.forward());
    super.initState();
  }

  int _countPrice () => (bookInfo.count * int.parse(widget.info.cost.substring(1, widget.info.cost.length))).toInt();

  @override
  Widget build(BuildContext context) {
    bookInfo._context = context;
    if (bookInfo.hasData && _bottomBtnCont.isDismissed) {
      _bottomBtnCont.forward();
    }
    return Scaffold(

      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top + AppBar().preferredSize.height,
              ),
              _setContainer (
                title: 'Restaurant',
                subtitle: widget.info.title,
                icon: Icons.info_outline,
                isTapped: false
              ),
              _setContainer (
                title: 'Location',
                subtitle: widget.address.addressLine,
                icon: CustomIcons.direction,
                onTap: () => MapUtils.openMap(widget.address.geoPoint.latitude, widget.address.geoPoint.longitude)
              ),
              _setContainer (
                title: 'Set date',
                subtitle: bookInfo.date,
                onTap: () => showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now() ,
                  lastDate:  DateTime.now().add(Duration(days: 10)),
                  builder: (context, child) {
                    return _dateTheme(child);
                  }
                ).then((value) => setState(() => bookInfo.setDate(value))),
                icon: CustomIcons.today
              ),
              _setContainer (
                title: 'Start time',
                subtitle: bookInfo.startTime,
                icon: CustomIcons.access_time,
                onTap: () => showTimePicker (
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (context, child) {
                    return _timeTheme(child);
                  }
                ).then((value) => setState(() => bookInfo.setStartTime(value)))
              ),
              _setContainer (
                title: 'End time',
                subtitle: bookInfo.endTime,
                icon: CustomIcons.access_time,
                onTap: () => showTimePicker (
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return _timeTheme(child);
                    }
                ).then((value) => setState(() => bookInfo.setEndTime(value)))
              ),
              _setContainer (
                title: 'People',
                subtitle: '0',
                icon: Icons.person_add,
                slider: true,
              ),
            ],
          ),
          AnimatedBuilder (
            animation: _routeCont,
            builder: (context, child) => Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: CloseBtn(_routeAnim.value)
                ),
                AnimatedBuilder(
                  animation: _bottomBtnCont,
                  builder: (context, child) => _bottomBtn (colorAnim: _bottomBtnAnim, routeAnim: _routeAnim),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
  Widget _setContainer ({String title, IconData icon, Function onTap, bool isTapped = true, String subtitle, bool slider = false}) => Center(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        width: MediaQuery
            .of(context)
            .size
            .width * .95,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0))
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(17.0),
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child:  ListTile(
                title: !slider ? Text(
                  subtitle,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0
                  ),
                ) : CupertinoSlider(
                  value: bookInfo.count,
                  max: 10,
                  min: 1,
                  divisions: 9,
                  activeColor: Colors.orange,
                  onChanged: (double value) => setState(() => bookInfo.setPeople(value)),
                ),
                leading: Icon(icon, color: Colors.orange,),
                trailing: slider ? Text(
                  bookInfo.count.toInt().toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0
                  ),
                ) : isTapped ? Icon(Icons.chevron_right, color: Colors.orange,) : null,
              )
            ),
          ],
        ),
      ),
    ),
  );

  Widget _bottomBtn ({Animation<Color> colorAnim, Animation<double> routeAnim}) => Transform.translate(
    offset: Offset( 0, MediaQuery.of(context).size.height - AppBar().preferredSize.height * routeAnim.value),
    child: GestureDetector(
      onTap: () => _bottomBtnCont.forward(),
      child: Container(
        height: AppBar().preferredSize.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration (
          color: colorAnim.value,
          boxShadow: [
            BoxShadow(
              blurRadius: 7.0,
              spreadRadius: -1.0,
              color: Color.fromRGBO(0, 0, 0, 0.25),
            )
          ]
        ),
        child: Center(
          child: Text(
            'Buy Now (₴${_countPrice()})',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0
            ),
          )
        ),
      ),
    ),
  );
}


class BookInfo {
  final Map<int,String> _monthsInYear = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    12: "Dec"
  };
  double _peopleCount = 1;
  DateTime _date;
  String _startTime = '';
  String _endTime = '';
  BuildContext _context;

  String get date =>  _date == null ? '' : '${_monthsInYear[_date.month]} ${_date.day}, ${_date.year}';

  double get count =>  _peopleCount;

  String get startTime =>  _startTime ?? '';

  String get endTime =>  _endTime ?? '';

  bool get hasData => _date != null && _startTime != null && _endTime != null;

  void setPeople (double count) => _peopleCount = count;

  void setStartTime (TimeOfDay time) => _startTime = time.format(_context);

  void setEndTime (TimeOfDay time) => _endTime = time.format(_context);

  void setDate (DateTime curDate) => _date = curDate;
}