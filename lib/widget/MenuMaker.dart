import 'package:flutter/material.dart';

class MenuMaker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MenuMakerState();
}

class _MenuMakerState extends State<MenuMaker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            padding: EdgeInsets.only(top: 70),
            color: Color(0x6dabe7cb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  Text(
                    "Air Quality Monitor",
                    style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Color(0xd364eeaf)),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.touch_app_outlined,
                      color: Colors.blueGrey,
                      size: 40,
                    ),
                    title: Text('Connect',style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xd3717975))),
                    onTap: () => Navigator.pushNamed(context, 'connection'),
                  ),
                  SizedBox(height: 15,),
                  ListTile(
                    leading: Icon(
                      Icons.web_rounded,
                      color: Colors.blueGrey,
                      size: 40,
                    ),
                    title: Text('Logs',style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xd3717975))),
                    onTap: () => Navigator.pushNamed(context, 'log'),
                  ),
                ]),
              ],
            )));
  }
}
