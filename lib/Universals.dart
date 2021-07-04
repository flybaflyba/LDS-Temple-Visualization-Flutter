

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spiral_vis/Circle.dart';
import 'package:url_launcher/url_launcher.dart';

String startYear = 'Loading';
String endYear = 'Loading';

List<Circle> circles = [];

int theta = 7000;

Future<void> launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}
List<String> names = [];

List<String> years = [];

List<String> distinctYears = [];

List<List<double>> coordinatesAndSizes = [];

List<int> searchedCircleIndexes = [];

String searchingByName = '';

bool loadingAssets = true;

double loaded = 0.0;

int totalCircles = 0;

void showToast(String message, bool warning) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 2,
    backgroundColor: warning ? Colors.red : Colors.blue,
    textColor: Colors.white,
    fontSize: 16.0,
    webBgColor: warning ? "linear-gradient(to right, #cc00ff, #ff0000)" : "	linear-gradient(to right, #00b09b, #96c93d)",

  );
}