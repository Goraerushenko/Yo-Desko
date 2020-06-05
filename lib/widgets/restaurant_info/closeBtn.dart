import 'package:flutter/material.dart';


class CloseBtn extends StatelessWidget {
  CloseBtn (
      this.opacity
  );
  final double opacity;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, left: 10),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle
            ),
            child: Center(
              child: Icon(Icons.close, color: Colors.white,),
            ),
          ),
        ),
      ),
    );
  }
}
