import 'package:air_quality_monitor/model/Air.dart';
import 'package:air_quality_monitor/server/IAirWS.dart';
import 'package:geolocator/geolocator.dart';

class DataHandler {
  String value;
  Position position;
  IAirWS iAirWS;

  DataHandler(this.value);

  Future<void> readValues(value) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Air airEntry = stringFormatter(value, position);
    await iAirWS.sendAirEntry(airEntry);
  }

  Air stringFormatter(value, position) {
    Air airEntry;
    //todo
    return airEntry;
  }
}
