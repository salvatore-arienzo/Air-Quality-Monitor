import 'package:air_quality_monitor/views/ConnectionView.dart';
import 'package:air_quality_monitor/views/LogView.dart';
import 'package:air_quality_monitor/views/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'views/Homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MaterialApp(
            title: 'Air Quality Monitor',
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
            routes: {
              'homepage': (BuildContext context) => Homepage(),
              'log': (BuildContext context) => LogView(),
              'connection': (BuildContext context) => ConnectionView(),
            },
          )));
}
