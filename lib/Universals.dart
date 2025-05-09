import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spiral_vis/Circle.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'WebViewPage.dart';

String startYear = 'Loading';
String endYear = 'Loading';

List<Circle> circles = [];

int theta = 2240;

int noOfCircles = 1;

Future<void> launchInBrowser(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
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

String spiralStyle = 'Default';

bool firstTime = true;

void showToast(String message, bool warning) {

  if(!kIsWeb) {
    Fluttertoast.cancel();
  }

  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    backgroundColor: warning ? Colors.red : Colors.blue,
    textColor: Colors.white,
    fontSize: 16.0,
    webBgColor: warning ? "linear-gradient(to right, #cc00ff, #ff0000)" : "	linear-gradient(to right, #00b09b, #96c93d)",

  );
}

void goToWebPage(BuildContext context, String url, String title) {
  if(kIsWeb) {
    launchInBrowser(url);
  } else {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) =>
            WebViewPage(url: url, name: title,)
        ));
  }

}