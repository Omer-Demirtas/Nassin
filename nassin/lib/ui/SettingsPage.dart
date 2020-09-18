


import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _SettingsPage();
  }
}

class _SettingsPage extends State<SettingsPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        child: Column(
          children: [
            FlatButton(
              child: Text("change color"),
              onPressed: () {
              },
        ),
          ],
        ),
      ),
    );
  }
}