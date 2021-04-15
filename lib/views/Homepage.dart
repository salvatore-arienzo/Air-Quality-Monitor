import 'dart:async';

import 'package:air_quality_monitor/model/Air.dart';
import 'package:air_quality_monitor/widget/AppBarMaker.dart';
import 'package:air_quality_monitor/widget/MenuMaker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoder/geocoder.dart';
import 'package:air_quality_monitor/DataHandler.dart';

class Homepage extends StatefulWidget {
  DataHandler dataHandler;

  Homepage(this.dataHandler);

  @override
  _HomepageState createState() => _HomepageState();
}

var coordinates;
var locationResult;
var addresses;

String locality = "";
String country = "";
String area = "";
String location = "";

class _HomepageState extends State<Homepage> {
  int color = 0xffabd537;
  String score = "";
  String pm = "0";
  String co = "0";
  String co2 = "0";
  String acetone = "0";
  String toluene = "0";
  String alcohol = "0";
  String nh4 = "0";
  String humidity = "0";
  String temperature = "0";
  double latitude = 0;
  double longitude = 0;

  void setQuality() {
    if (pm == "0") {
      score = "";
    } else {
      double pmScore = double.parse(pm);
      double coScore = double.parse(co);
      double co2Score = double.parse(co2);

      if (pmScore <= 12 && coScore <= 50 && co2Score <= 1000) {
        score = "Normal values";
        color = 0xffabd537;
      } else if ((pmScore > 12 && pmScore <= 35) ||
          (coScore > 50 && coScore <= 100) ||
          (co2Score > 1000 && co2Score <= 2000)) {
        score = "Moderate values";
        color = 0xffe0752f;
      } else if ((pmScore > 35) || (coScore > 100) || (co2Score > 2000)) {
        score = "Unhealthy values";
        color = 0xffec3535;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    Timer(Duration(seconds: 1), () async {
      //auto refresh of the page to update values
      Air air = await widget.dataHandler.getAir();
      pm = air.Pm.toString();
      co = air.Co.toString();
      co2 = air.Co2.toString();
      acetone = air.Acetone.toString();
      toluene = air.Toluene.toString();
      alcohol = air.Alcohol.toString();
      nh4 = air.Nh4.toString();
      humidity = air.Humidity.toString();
      temperature = air.Temperature.toString();
      latitude = air.Latitude;
      longitude = air.Longitude;
      const oneSec = const Duration(seconds: 1);
      new Timer.periodic(
          oneSec,
          (Timer t) => setState(() {
                getLocation();
                setQuality();
              }));
    });
  }

  Future<String> getLocation() async {
    try {
      /*Function to build the address of the latest measurement, with format
    Location: City, Region, Country. */
      coordinates = new Coordinates(latitude, longitude);
      addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      locationResult = addresses.first;
      locality = locationResult.locality;
      area = locationResult.adminArea;
      country = locationResult.countryName;
      return location = locality + ", " + area + ", " + country;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: makeAppBar('Homepage'),
        drawer: MenuMaker(),
        backgroundColor: Color(0xff9ce8c5),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 30),
            child: Column(children: <Widget>[
              Row(children: <Widget>[
                Text("Latest Measurement:",
                    style: TextStyle(
                      fontSize: 25,
                    )),
                FlatButton.icon(
                  label: Container(),
                  icon: Icon(Icons.refresh),
                  onPressed: () async {
                    Air air = await widget.dataHandler.getAir();
                    pm = air.Pm.toString();
                    co = air.Co.toString();
                    co2 = air.Co2.toString();
                    acetone = air.Acetone.toString();
                    toluene = air.Toluene.toString();
                    alcohol = air.Alcohol.toString();
                    nh4 = air.Nh4.toString();
                    humidity = air.Humidity.toString();
                    temperature = air.Temperature.toString();
                    latitude = air.Latitude;
                    longitude = air.Longitude;
                    getLocation();
                    setQuality();
                    setState(() {});
                  },
                ),
              ]),
              SizedBox(
                height: 10,
              ),
              Row(children: <Widget>[
                Text("Location: ",
                    style: TextStyle(
                      fontSize: 22,
                    )),
                Text(location,
                    style: TextStyle(
                      fontSize: 16,
                    )),
              ]),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 60.0,
                    width: 370,
                    decoration: BoxDecoration(
                        color: Color(color),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    child: new Row(children: <Widget>[
                      Text(
                        " Overall Quality: ",
                        style: TextStyle(fontSize: 25, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        score,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                    ]),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Text(
                    " PM:  ",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 40.0,
                    width: 140,
                    decoration: BoxDecoration(
                        color: Color(0xffe5e36e),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: new Row(children: <Widget>[
                      Text(
                        pm,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      Text(
                        "  ug/m3",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      )
                    ]),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: <Widget>[
                  Text(
                    "  CO:  ",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 40.0,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Color(0xff99d79a),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: new Row(children: <Widget>[
                      Text(
                        co,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      Text(
                        "  ppm",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ]),
                  ),
                  Text(
                    " Alcohol:  ",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 40.0,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Color(0xff99d79a),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: new Row(children: <Widget>[
                      Text(
                        alcohol,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      Text(
                        "  ppm",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      )
                    ]),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: <Widget>[
                  Text(
                    "CO2:  ",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 40.0,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Color(0xff99d79a),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: new Row(children: <Widget>[
                      Text(
                        co2,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      Text(
                        "  ppm",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ]),
                  ),
                  Text(
                    "Toluene:  ",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 40.0,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Color(0xff99d79a),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: new Row(children: <Widget>[
                      Text(
                        toluene,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      Text(
                        "  ppm",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      )
                    ]),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: <Widget>[
                  Text(
                    "NH4:  ",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 40.0,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Color(0xff99d79a),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: new Row(children: <Widget>[
                      Text(
                        nh4,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      Text(
                        "  ppm",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ]),
                  ),
                  Text(
                    "Acetone:  ",
                    style: TextStyle(fontSize: 19, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 40.0,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Color(0xff99d79a),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: new Row(children: <Widget>[
                      Text(
                        acetone,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      Text(
                        "  ppm",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      )
                    ]),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Humidity:  ",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 40.0,
                    width: 95,
                    decoration: BoxDecoration(
                        color: Color(0xff6dc2dc),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: new Row(children: <Widget>[
                      Text(
                        humidity,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      Text(
                        "  %",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ]),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Temperature:  ",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 40.0,
                    width: 95,
                    decoration: BoxDecoration(
                        color: Color(0xe4d79665),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: new Row(children: <Widget>[
                      Text(
                        temperature,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      Text(
                        "  °C",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ]),
                  ),
                ],
              ),
            ])));
  }
}
