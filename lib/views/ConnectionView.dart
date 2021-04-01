import 'package:air_quality_monitor/DataHandler.dart';
import 'package:air_quality_monitor/widget/AppBarMaker.dart';
import 'package:air_quality_monitor/widget/MenuMaker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:toast/toast.dart';

var connected = false;

class ConnectionView extends StatefulWidget {
  ConnectionView({Key key}) : super(key: key);

  @override
  _ConnectionViewState createState() => _ConnectionViewState();
}

class _ConnectionViewState extends State<ConnectionView> {
  DataHandler dataHandler;
  @override
  Widget build(BuildContext context) {
    var textButton;
    if (connected == false) {
      textButton = 'Connect';
    } else {
      textButton = 'Disconnect';
    }
    return Scaffold(
        appBar: makeAppBar('Connection'),
        drawer: MenuMaker(),
        backgroundColor: Color(0xff9ce8c5),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                    'Tap the button below to connect / disconnect your device. '
                    'Once connected, the application will start to read data automatically.',
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 40,
                ),
                FlatButton(
                  color: Colors.green,
                  height: 50,
                  child: Text(
                    textButton,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'connectionlist');
                  },
                ),
              ],
            )));
  }
}

class ConnectionListView extends StatefulWidget {
  ConnectionListView({Key key}) : super(key: key);

  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();
  final FlutterBlue flutterBlue = FlutterBlue.instance;

  @override
  _ConnectionListViewState createState() => _ConnectionListViewState();
}

class _ConnectionListViewState extends State<ConnectionListView> {
  List<BluetoothService> _services;
  DataHandler dataHandler;

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    widget.flutterBlue.startScan(); //start to scan for devices
  }

  @override
  Widget build(BuildContext context) {
    if (connected == false) {
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: makeAppBar('Connection'),
        drawer: MenuMaker(),
        backgroundColor: Color(0xff9ce8c5),
        body: _buildListViewOfDevices(),
      );
    } else {
      setConnectedState();
      Navigator.pushReplacementNamed(context, 'connection');
    }
  }

  void setConnectedState() {
    if (connected == false) {
      connected = true;
      Toast.show("Successfully Connected!", context,
          duration: 3, gravity: Toast.BOTTOM);
    } else {
      connected = false;
      Toast.show("Successfully Disconnected!", context,
          duration: 3, gravity: Toast.BOTTOM);
    }
  }

  ListView _buildListViewOfDevices() {
    List<Container> containers = new List<Container>();
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(device.name == '' ? '(Unknown)' : device.name),
                    Text(device.id.toString()),
                  ],
                ),
              ),
              FlatButton(
                color: Colors.green,
                child: Text(
                  "Connect",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  widget.flutterBlue.stopScan();
                  try {
                    await device.connect();
                  } catch (e) {
                    print(e.toString());
                  } finally {
                    _services = await device.discoverServices();
                    for (BluetoothService service in _services) {
                      if (service.uuid
                          .toString()
                          .contains("0000ffe0-0000-1000-8000-00805f9b34fb")) {
                        for (BluetoothCharacteristic c
                            in service.characteristics) {
                          if (c.uuid.toString().contains(
                              "0000ffe1-0000-1000-8000-00805f9b34fb")) {
                            c.setNotifyValue(true);
                            c.value.listen((value) async {
                              String data = new String.fromCharCodes(value);
                              dataHandler.readValues(value);
                            });
                          }
                        }
                      }
                    }
                  }
                  setConnectedState();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConnectionView()),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }
}
