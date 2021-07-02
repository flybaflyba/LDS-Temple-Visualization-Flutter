

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spiral_vis/Circle.dart';

Future<List<String>> readNamesAndYearsFile() async {
  String namesAndYearsText = await rootBundle.loadString('assets/texts/names_and_years.txt');
  List<String> namesAndYearsList = namesAndYearsText.split('\n');
  return namesAndYearsList;
}

Future<void> loadImages(BuildContext context) async {
  List<Circle> circles;
  List<String> namesAndYearsList = await readNamesAndYearsFile();

  // List<String> namesList = [];
  // List<String> yearsList = [];

  List<bool> imageAvailability = [];

  for(String s in namesAndYearsList) {
    // namesList.add(s.split(" ")[0]);
    // yearsList.add(s.split(" ")[1]);

    String name = s.split(" ")[0];
    String year = s.split(" ")[1];

    var realName = '';
    for(String s in name.split("_")){
      realName = realName + '${s[0].toUpperCase()}${s.substring(1)}' + " ";
    }
    print(realName);

    String imagePath = 'assets/images/' + name + '_large.webp';

    try {
      final bundle = DefaultAssetBundle.of(context);
      await bundle.load(imagePath);
      // print('we have this image');
      imageAvailability.add(true);
      Image image = Image.asset(imagePath);

    } catch (e) {
      Image image = Image.asset('assets/images/' + 'no_image' + '_large.webp');
      // print('no image');
      imageAvailability.add(false);
    }
  // print(image);
  }

  // print("imageAvailability is: " + imageAvailability.toString());

  // print('names length is: ' + namesList.length.toString());
  // // print(namesList);
  // print('yearsList length is: ' + yearsList.length.toString());
  // // print(yearsList);
  //
  // var temp = namesList[100].split(" ").first;
  // print(temp);



}