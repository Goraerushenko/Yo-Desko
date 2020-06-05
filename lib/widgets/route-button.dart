import 'package:com/pages/make-a-booking-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class RouteBtn extends StatelessWidget {

  RouteBtn ({
    this.page,
    this.showAnim,
    this.icon,
    this.text
  });
  final IconData icon;
  final String text;
  final Animation<double> showAnim;
  final MakeBookingPage page;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => page
            )
        ),
        child: Container(
            height: 50,
            width: 50 + (MediaQuery.of(context).size.width * .8 - 60) * showAnim.value,
            decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.all(Radius.circular(30.0))
            ),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: showAnim.isDismissed ? Alignment.center : Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: showAnim.isDismissed ? 0.0 : 10.0),
                    child: Icon(
                      icon,
                      color: Colors.black,
                      size: 20.0,
                    ),
                  ),
                ),
                Opacity(
                  opacity:  showAnim.value,
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0
                      ),
                    ),
                  ),
                ),
                Opacity(
                  opacity:  showAnim.value,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                        size: 30.0,
                      ),
                    ),
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}
