import 'package:flutter/material.dart';

class CurrentImageLines extends StatelessWidget {
  CurrentImageLines ({
    Key key,
    this.length,
    this.curPage,
    this.width,
    this.color
  }) : super (key: key);
  final Color color;
  final double width;
  final int length;
  final double curPage;

  List<int> _lenToArray (int length) {
    List<int> willReturn = [];
    for(int i = 0; i < length; i++){
      willReturn.add(i);
    }
    return willReturn;
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: _lenToArray(length).map(
              (i) {
            int _curPage = int.parse('${(curPage ?? 0.0)}'[0]);
            double nexPagePercent = (curPage ?? 0.0) - int.parse('${curPage ?? 0.0}'[0]);
            double curPagePercent = 1 - nexPagePercent;
            double allLinesWidth = width ?? (MediaQuery.of(context).size.width * .5);
            double oneLineWidth = allLinesWidth / length - 10 ;
            return Row(
              children: <Widget>[
                Container(
                  height: 5,
                  width: oneLineWidth,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  child: _curPage == i || _curPage + 1 == i  ? Align(
                    alignment:  _curPage == i ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      height: 5,
                      width: oneLineWidth*  (_curPage == i ? curPagePercent : nexPagePercent),
                      decoration: BoxDecoration(
                          color: color ?? Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.0))
                      ),
                    ),
                  ) : Container(),
                ),
                SizedBox(
                  width: 10.0 ,
                )
              ],
            );
          }
      ).toList(),
    );
  }
}

