import 'package:air_quality_monitor/DataHandler.dart';
import 'package:air_quality_monitor/widget/AppBarMaker.dart';
import 'package:air_quality_monitor/widget/MenuMaker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LogView extends StatefulWidget {

  LogView(DataHandler dataHandler);

  @override
  _LogViewState createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: makeAppBar('Logs'),
      drawer: MenuMaker(),
      backgroundColor: Color(0xff9ce8c5),
    );
  }
}
