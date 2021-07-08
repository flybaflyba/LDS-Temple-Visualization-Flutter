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
 * TODO 1. change see more photos on line on single view search term to include 'lds'
    in case some un-relevant photos to show up, eg for shanghai temple
    2. change initial loading to top bar, load spiral with blank circles
    so that users can interact with spiral while images are still loading
    3. fix refreshing adding extra names and years to picker lists, for both names and years.

 **/