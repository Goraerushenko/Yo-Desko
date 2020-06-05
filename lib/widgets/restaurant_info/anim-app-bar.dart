import 'package:flutter/material.dart';

class AnimAppBar extends StatefulWidget {
  AnimAppBar ({
    Key key,
    this.listCont,
    this.title,
  }) : super (key: key);
  final String title;
  final ScrollController listCont;

  @override
  _AnimAppBarState createState() => _AnimAppBarState();
}

class _AnimAppBarState extends State<AnimAppBar> with TickerProviderStateMixin{
  AnimationController _slideCont;
  Animation<double> _slideAnim;
  @override
  void initState() {
    _slideCont = AnimationController (vsync: this, duration: Duration(milliseconds: 200));
    _slideAnim = Tween(begin: 1.0, end: 0.0).animate(_slideCont)..addListener(() => setState(() {}));
    widget.listCont?.addListener(() {
      if (widget.listCont.offset > 65 && _slideCont.isDismissed) {
        _slideCont.forward();
      } else if (widget.listCont.offset < 65 &&_slideCont.isCompleted) {
        _slideCont.reverse();
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: Offset(0, -(AppBar().preferredSize.height + MediaQuery.of(context).padding.top) * _slideAnim?.value ?? 1.0),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).padding.top,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
              ),
              Container(
                height: AppBar().preferredSize.height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4.0,
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          offset: Offset(0, 2)
                      )
                    ]
                ),
                child: Align (
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.grey[700], size: 25.0,),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24.0
                          ),
                        )
                      ],
                    )
                  )
                ),
              )
            ],
          )
        ),
      ],
    );
  }
}

