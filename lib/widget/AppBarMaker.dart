import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

AppBar makeAppBar(String title) {
  return AppBar(
      textTheme: TextTheme(
          headline6: TextStyle(color: Color(0xff343434), fontSize: 20)),
      title: Text(title, textAlign: TextAlign.center),
      iconTheme: IconThemeData(color: Color(0xff343434)),
      backgroundColor: Color(0xd364eeaf),
      elevation: 10);
}