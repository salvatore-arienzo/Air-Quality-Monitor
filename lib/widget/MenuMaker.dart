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
            padding: EdgeInsets.only(top: 35),
            color: Color(0x6dabe7cb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  ListTile(
                    leading: Icon(Icons.hail),
                    title: Text('Connect'),
                    onTap: () => Navigator.pushNamed(context, 'homepage'),
                  ),
                ]),
                Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Log out'),
                      onTap: () {},
                    )
                  ],
                )
              ],
            )));
  }
}
