import 'package:com/models/restuarant/rating-model.dart';
import 'package:flutter/material.dart';


class Stars extends StatelessWidget {

  Stars (
    this.raiting,
    {this.size = 14.0}
  );

  final Rating raiting;
  final double size;

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: <Widget>[
        Text(
          raiting.stars.toString(),
          style: TextStyle(
              color: Colors.grey[600],
              fontSize: size - 2,
              fontWeight: FontWeight.bold
          ),
        ),
        Row (
          children: [1,2,3,4,5].map((e) => Icon(
            Icons.star,
            color: e <= raiting.stars.floor() ? Colors.orangeAccent : Colors.grey,
            size: size,
          )).toList(),
        ),
        Text(
          '(${raiting.votedPeople})',
          style: TextStyle(
              color: Colors.grey[600],
              fontSize: size - 2
          ),
        ),
        Icon(
            Icons.chevron_right,
          color: Colors.grey,
          size: size,
        )
      ],
    );
  }
}
