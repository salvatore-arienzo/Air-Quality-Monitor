import 'dart:convert';
import 'package:air_quality_monitor/model/Air.dart';
import 'package:air_quality_monitor/server/IAirWS.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class RestAirWs implements IAirWS {
  static var client = http.Client();
  static const timeoutDuration = Duration(seconds: 5);
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
        double airPm = jsonObj['Pm'];
        double airCo = jsonObj['Co'];
        double airAlcohol = jsonObj['Alcohol'];
        double airCo2 = jsonObj['Co2'];
        double airToluene = jsonObj['Toluene'];
        double airNh4 = jsonObj['Nh4'];
        double airAcetone = jsonObj['Acetone'];
        double airHumidity = jsonObj['Humidity'];
        double airTemperature = jsonObj['Temperature'];
        double airLatitude = jsonObj['Latitude'];
        double airLongitude = jsonObj['Longitude'];
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
      double airPm = jsonObj['Pm'];
      double airCo = jsonObj['Co'];
      double airAlcohol = jsonObj['Alcohol'];
      double airCo2 = jsonObj['Co2'];
      double airToluene = jsonObj['Toluene'];
      double airNh4 = jsonObj['Nh4'];
      double airAcetone = jsonObj['Acetone'];
      double airHumidity = jsonObj['Humidity'];
      double airTemperature = jsonObj['Temperature'];
      double airLatitude = jsonObj['Latitude'];
      double airLongitude = jsonObj['Longitude'];
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
      print("Error while fetching latest measurement");
      return null;
    }
  }

  @override
  Future<Air> sendAirEntry(Air airEntry) async {
    try {
      Response response = await client.post(server + '/air/entry/', body: {
        'Pm': airEntry.Pm,
        'Co': airEntry.Co,
        'Alcohol': airEntry.Alcohol,
        'Co2': airEntry.Co2,
        'Toluene': airEntry.Toluene,
        'Nh4': airEntry.Nh4,
        'Acetone': airEntry.Acetone,
        'Humidity': airEntry.Humidity,
        'Temperature': airEntry.Temperature,
        'Latitude': airEntry.Latitude,
        'Longitude': airEntry.Longitude,
      }).timeout(timeoutDuration, onTimeout: () => throw 'timeout');
      var jsonObj = jsonDecode(response.body);
      double airPm = jsonObj['Pm'];
      double airCo = jsonObj['Co'];
      double airAlcohol = jsonObj['Alcohol'];
      double airCo2 = jsonObj['Co2'];
      double airToluene = jsonObj['Toluene'];
      double airNh4 = jsonObj['Nh4'];
      double airAcetone = jsonObj['Acetone'];
      double airHumidity = jsonObj['Humidity'];
      double airTemperature = jsonObj['Temperature'];
      double airLatitude = jsonObj['Latitude'];
      double airLongitude = jsonObj['Longitude'];
      return Air(airPm, airCo, airAlcohol, airCo2, airToluene, airNh4,
          airAcetone, airHumidity, airTemperature, airLatitude, airLongitude);
    } catch (e) {
      print("Unable to send air entry");
      return null;
    }
  }
}
