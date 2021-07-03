

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