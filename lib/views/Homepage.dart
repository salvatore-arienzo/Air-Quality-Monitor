import 'package:air_quality_monitor/widget/AppBarMaker.dart';
import 'package:air_quality_monitor/widget/MenuMaker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: makeAppBar('Homepage'),
      drawer: MenuMaker(),
      backgroundColor: Color(0xff9ce8c5),
    );
  }
}
