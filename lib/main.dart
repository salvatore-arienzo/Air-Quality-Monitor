import 'package:air_quality_monitor/impl/RestAirWs.dart';
import 'package:air_quality_monitor/views/ConnectionView.dart';
import 'package:air_quality_monitor/views/LogView.dart';
import 'package:air_quality_monitor/views/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'DataHandler.dart';

import 'views/Homepage.dart';

void main() {
  final DataHandler dataHandler = DataHandler();
  WidgetsFlutterBinding.ensureInitialized();
  final String localhost = 'http://192.168.1.86:8080/';
  var restUserWs = RestAirWs(localhost);
  dataHandler.setAirWs(restUserWs);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MaterialApp(
            title: 'Air Quality Monitor',
            debugShowCheckedModeBanner: false,
            home: SplashScreen(dataHandler),
            routes: {
              'homepage': (BuildContext context) => Homepage(dataHandler),
              'log': (BuildContext context) => LogView(dataHandler),
              'connection': (BuildContext context) => ConnectionView(dataHandler),
              'connectionlist': (BuildContext context) => ConnectionListView(dataHandler),
            },
          )));
}
