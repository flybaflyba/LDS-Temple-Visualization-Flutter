import 'package:flutter/material.dart';

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
      body: Center(
        child: Text('Settings'),
      )
    );
  }
}

/**
 * TODO
    1. fix refreshing adding extra names and years to picker lists, for both names and years.
    2. https://pub.dev/packages/gzx_dropdown_menu

 **/