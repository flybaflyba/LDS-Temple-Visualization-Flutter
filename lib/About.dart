import 'package:flutter/material.dart';
import 'package:spiral_vis/Universals.dart';

var about = SingleChildScrollView(
  child: ListBody(
    children: <Widget>[
      Text('Programming by Tsz Chin Lam, Abigail Smith, and Litian Zhang under the supervision of Dr. Geoffrey Draper at Brigham Young University--Hawaii.'),
      Text(''),
      Text('Temple photos are copyrighted by Intellectual Reserve, Inc. Used by permission.'),
      Text(''),
      Text('This app is a research project funded by Brigham Young University--Hawaii, however the contents are the responsibility of its developers. This app is not an \"official\" publication of the Church of Jesus Christ of Latter-day Saints.'),
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
);