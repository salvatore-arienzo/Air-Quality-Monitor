import 'package:air_quality_monitor/model/Air.dart';
import 'package:air_quality_monitor/server/IAirWS.dart';
import 'package:geolocator/geolocator.dart';

class DataHandler {
  String value;
  Position position;
  IAirWS iAirWS;

  void init() {
    setAirWs(iAirWS);
  }

  void setAirWs(IAirWS airWS) {
    this.iAirWS = airWS;
  }

  void readValues(value) async {
    double latitude;
    double longitude;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude;
    longitude = position.longitude;
    Air airEntry = stringFormatter(value, latitude, longitude);
    if (airEntry.Pm != 0.00) {
      //PM sensor sometimes gives missing values
      await iAirWS.sendAirEntry(airEntry);
    }
  }

  Air stringFormatter(value, latitude, longitude) {
    Air airEntry;
    List airList = value.split(new RegExp(r"[,]"));
    airEntry = new Air(
        double.parse(airList[0]),
        double.parse(airList[1]),
        double.parse(airList[2]),
        double.parse(airList[3]),
        double.parse(airList[4]),
        double.parse(airList[5]),
        double.parse(airList[6]),
        double.parse(airList[7]),
        double.parse(airList[8]),
        latitude,
        longitude);
    return airEntry;
  }

  Future<Air> getAir() async {
    Air air = await iAirWS.getLatestMeasurement();
    return air;
  }
}
