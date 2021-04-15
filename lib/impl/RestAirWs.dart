import 'dart:convert';
import 'package:air_quality_monitor/model/Air.dart';
import 'package:air_quality_monitor/server/IAirWS.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class RestAirWs implements IAirWS {
  static var client = http.Client();
  static const timeoutDuration = Duration(seconds: 10);
  String server;
  RestAirWs(this.server);

  @override
  Future<List<Air>> getAllEntries() async {
    try {
      List<Air> airEntries = List();
      Response response = await client
          .get(server + '/air/getall')
          .timeout(timeoutDuration, onTimeout: () => throw 'timeout');
      var jsonList = jsonDecode(response.body);
      for (var jsonObj in jsonList) {
        double airPm = jsonObj['pm'];
        double airCo = jsonObj['co'];
        double airAlcohol = jsonObj['alcohol'];
        double airCo2 = jsonObj['co2'];
        double airToluene = jsonObj['toluene'];
        double airNh4 = jsonObj['nh4'];
        double airAcetone = jsonObj['acetone'];
        double airHumidity = jsonObj['humidity'];
        double airTemperature = jsonObj['temperature'];
        double airLatitude = jsonObj['latitude'];
        double airLongitude = jsonObj['longitude'];
        Air newAirEntry = new Air(
            airPm,
            airCo,
            airAlcohol,
            airCo2,
            airToluene,
            airNh4,
            airAcetone,
            airHumidity,
            airTemperature,
            airLatitude,
            airLongitude);
        airEntries.add(newAirEntry);
      }
      return airEntries;
    } catch (e) {
      print("Error while fetching");
      return null;
    }
  }

  @override
  Future<Air> getLatestMeasurement() async {
    try {
      Response response = await client
          .get(server + '/air/')
          .timeout(timeoutDuration, onTimeout: () => throw 'timeout');
      var jsonObj = jsonDecode(response.body);
      double airPm = jsonObj['pm'];
      double airCo = jsonObj['co'];
      double airAlcohol = jsonObj['alcohol'];
      double airCo2 = jsonObj['co2'];
      double airToluene = jsonObj['toluene'];
      double airNh4 = jsonObj['nh4'];
      double airAcetone = jsonObj['acetone'];
      double airHumidity = jsonObj['humidity'];
      double airTemperature = jsonObj['temperature'];
      double airLatitude = jsonObj['latitude'];
      double airLongitude = jsonObj['longitude'];
      Air newAirEntry = new Air(
          airPm,
          airCo,
          airAlcohol,
          airCo2,
          airToluene,
          airNh4,
          airAcetone,
          airHumidity,
          airTemperature,
          airLatitude,
          airLongitude);
      return newAirEntry;
    } catch (e) {
      print(e);
      print("Error while fetching latest measurement");
      return null;
    }
  }

  @override
  Future<void> sendAirEntry(Air airEntry) async {
    try {
      Response response = await client.post(server + '/air/entry/', body: {
        'Pm': airEntry.Pm.toString(),
        'Co': airEntry.Co.toString(),
        'Alcohol': airEntry.Alcohol.toString(),
        'Co2': airEntry.Co2.toString(),
        'Toluene': airEntry.Toluene.toString(),
        'Nh4': airEntry.Nh4.toString(),
        'Acetone': airEntry.Acetone.toString(),
        'Humidity': airEntry.Humidity.toString(),
        'Temperature': airEntry.Temperature.toString(),
        'Latitude': airEntry.Latitude.toString(),
        'Longitude': airEntry.Longitude.toString(),
      }).timeout(timeoutDuration, onTimeout: () => throw 'timeout');
    } catch (e) {
      print("Unable to send air entry");
      print(e.toString());
      return null;
    }
  }
}
