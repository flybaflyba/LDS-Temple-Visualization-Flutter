import 'package:flutter/material.dart';
import 'package:spiral_vis/About.dart';
import 'package:spiral_vis/Universals.dart';

class Settings extends StatefulWidget{

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
      body: ListView(
        children: [
          Checkbox(
            checkColor: Colors.lightBlueAccent,
            value: showLabel,
            onChanged: (bool value) {
              setState(() {
                showLabel = value;
              });
            },
          ),
          aboutButton(context),
        ],
      )
    );
  }
}