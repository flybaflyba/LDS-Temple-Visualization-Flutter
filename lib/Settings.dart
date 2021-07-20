import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'Universals.dart';

class Settings extends StatefulWidget{

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('More'),
        ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: IconButton(
                icon: const Icon(Icons.link),
                color: Colors.blue,
                tooltip: 'App Website',
                onPressed: () {
                  launchInBrowser('https://latterdaytemples.litianzhang.com/related-links-english/');

                  // TODO mobile version, open in web view
                }
            ),
          ),

          Padding(
            padding: EdgeInsets.all(10),
            child: IconButton(
                icon: const Icon(Icons.ios_share),
                color: Colors.blue,
                tooltip: 'Share',
                onPressed: () {
                  Share.share('Temples Timeline App \nSpiral Visualization for the temples of The Church of Jesus Christ of Latter-day Saints by students and professors at Brigham Young University Hawaii.\n Visit at https://latterdaytemples.litianzhang.com/');
                }
            ),
          ),

        ],
      )
    );
  }
}

/**
 * TODO 1. add different effect

 **/