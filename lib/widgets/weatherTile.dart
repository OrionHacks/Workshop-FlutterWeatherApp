import 'package:flutter/material.dart';

Widget weatherTile(String name, String val, String unit) {
  return Container(
    width: 100,
    height: 100,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
        ),
        Text(
          val.toString(),
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300),
        ),
        Text(
          unit,
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}
