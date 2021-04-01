import 'dart:async';

import 'package:air_quality_monitor/widget/AppBarMaker.dart';
import 'package:air_quality_monitor/widget/MenuMaker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoder/geocoder.dart';

class Homepage extends StatefulWidget {
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
  @override
  void initState() {
    super.initState();
    getLocation();
    Timer(Duration(seconds: 1), () {
      //auto refresh of the page to update values
      setState(() {});
    });
  }

  Future<String> getLocation() async {
    /*Function to build the address of the latest measurement, with format
    Location: City, Region, Country. */
    coordinates = new Coordinates(40.7738, 14.8003);
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    locationResult = addresses.first;
    locality = locationResult.locality;
    area = locationResult.adminArea;
    country = locationResult.countryName;
    return location = locality + ", " + area + ", " + country;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: makeAppBar('Homepage'),
        drawer: MenuMaker(),
        backgroundColor: Color(0xff9ce8c5),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(children: <Widget>[
              Row(children: <Widget>[
                Text("Latest Measurement:",
                    style: TextStyle(
                      fontSize: 25,
                    )),
                FlatButton.icon(
                  label: Container(),
                  icon: Icon(Icons.refresh),
                  onPressed: () {
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
                height: 40,
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
                    width: 95,
                    decoration: BoxDecoration(
                        color: Color(0xffe5e36e),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: new Row(children: <Widget>[
                      Text(
                        "9,9",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      Text(
                        "  %",
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
                    width: 95,
                    decoration: BoxDecoration(
                        color: Color(0xff99d79a),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: new Row(children: <Widget>[
                      Text(
                        "1,2",
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
                  Text(
                    " Alcohol:  ",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 40.0,
                    width: 95,
                    decoration: BoxDecoration(
                        color: Color(0xff99d79a),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: new Row(children: <Widget>[
                      Text(
                        "1,2",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      Text(
                        "  %",
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
                    width: 95,
                    decoration: BoxDecoration(
                        color: Color(0xff99d79a),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: new Row(children: <Widget>[
                      Text(
                        "400",
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
                  Text(
                    "Toluene:  ",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 40.0,
                    width: 95,
                    decoration: BoxDecoration(
                        color: Color(0xff99d79a),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: new Row(children: <Widget>[
                      Text(
                        "1,2",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      Text(
                        "  %",
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
                    width: 95,
                    decoration: BoxDecoration(
                        color: Color(0xff99d79a),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: new Row(children: <Widget>[
                      Text(
                        "1,2",
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
                  Text(
                    "Acetone:  ",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 40.0,
                    width: 95,
                    decoration: BoxDecoration(
                        color: Color(0xff99d79a),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: new Row(children: <Widget>[
                      Text(
                        "1,2",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      Text(
                        "  %",
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
                        "1,2",
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
                        "1,2",
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
            ])));
  }
}
