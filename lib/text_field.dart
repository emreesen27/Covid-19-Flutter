import 'package:flutter/material.dart';

Widget textField({String desc, String value, Color color}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          width: 20,
          height: 20,
          child: CircleAvatar(
            backgroundColor: color,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: Text(
          '$desc',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Text(
        '$value',
        style: TextStyle(fontSize: 19, color: Colors.black87),
      ),
    ],
  );
}
