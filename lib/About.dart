import 'package:flutter/material.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:spiral_vis/Universals.dart';


SpeedDialChild aboutButton(BuildContext context) {
  return SpeedDialChild(
    child: const Icon(Icons.help),
    foregroundColor: Colors.white,
    backgroundColor: Colors.green,
    label: 'About the App',
    onPressed: () {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('About Temples Timeline'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Programming by Tsz Chin Lam, Abigail Smith, and Litian Zhang under the supervision of Dr. Geoffrey Draper at Brigham Young University--Hawaii.'),
                  Text(''),
                  Text('Temple photos are copyrighted by Intellectual Reserve, Inc. Used by permission.'),
                  Text(''),
                  Text('This app is a research project funded by Brigham Young University--Hawaii, however the contents are the responsibility of its developers. This app is not an \"official\" publication of the Church of Jesus Christ of Latter-day Saints.'),
                  Text(''),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      launchInBrowser('https://latterdaytemples.litianzhang.com/');
                    },
                    child: Text('Visit App website'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    },
  );


    IconButton(
    icon: const Icon(Icons.help),
    color: Colors.lightBlueAccent,
    tooltip: 'About',
    onPressed: () {

    },
  );
}