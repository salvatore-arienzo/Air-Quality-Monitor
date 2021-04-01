

import 'package:air_quality_monitor/model/Air.dart';

abstract class IAirWS {

  Future<Air> sendAirEntry(Air airEntry);

  Future<Air> getLatestMeasurement();

  Future<List<Air>> getAllEntries();

}