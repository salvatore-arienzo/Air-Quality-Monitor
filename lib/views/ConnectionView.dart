import 'package:air_quality_monitor/widget/AppBarMaker.dart';
import 'package:air_quality_monitor/widget/MenuMaker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConnectionView extends StatefulWidget {
  @override
  _ConnectionViewState createState() => _ConnectionViewState();
}

class _ConnectionViewState extends State<ConnectionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: makeAppBar('Connection'),
      drawer: MenuMaker(),
      backgroundColor: Color(0xff9ce8c5),
    );
  }
}
