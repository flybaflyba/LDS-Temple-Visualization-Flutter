

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spiral_vis/Circle.dart';
import 'package:spiral_vis/Universals.dart';

Future<List<String>> readNamesAndYearsFile() async {
  String namesAndYearsText = await rootBundle.loadString('assets/texts/names_and_years.txt');
  List<String> namesAndYearsList = namesAndYearsText.split('\n');
  return namesAndYearsList;
}

Future<void> loadImages(BuildContext context) async {
  // List<Circle> circles = [];
  List<String> namesAndYearsList = await readNamesAndYearsFile();

  // List<String> namesList = [];
  // List<String> yearsList = [];

  print('loading images');

  bool imageAvailability;

  totalCircles = namesAndYearsList.length;

  for(String s in namesAndYearsList) {
    // namesList.add(s.split(" ")[0]);
    // yearsList.add(s.split(" ")[1]);

    String name = s.split(" ")[0];
    String year = s.split(" ")[1];

    var realName = '';
    for(String s in name.split("_")){
      realName = realName + '${s[0].toUpperCase()}${s.substring(1)}' + " ";
    }
    // print(realName);

    names.add(realName);

    if(year == '0000') {
      year = 'Under Construction';
    } else if(year == '1111'){
      year = 'Announced Temples';
    }

    years.add(year);

    String imagePath = 'assets/small_circles/' + name + '.webp';

    final manifestJson = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final imagesInAssets = json.decode(manifestJson).keys.where((String key) => key.startsWith('assets/small_circles'));
    // print(imagesInAssets);

    Image image;

    Uint8List imageData;


    // print(imagePath);
    if(imagesInAssets.contains(imagePath)){

      imageData = (await rootBundle.load(imagePath))
          .buffer
          .asUint8List();

      // print('we have this image');
      imageAvailability = true;
      image = Image.asset(
        imagePath,
        fit: BoxFit.fill,
        filterQuality: FilterQuality.none,
        frameBuilder: (BuildContext context, Widget child, int frame,
            bool wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            return child;
          }
          return AnimatedOpacity(
            child: child,
            opacity: frame == null ? 0 : 1,
            duration: const Duration(seconds: 2),
            curve: Curves.easeOut,
          );
        },
      );
    } else {
      // print('missing image');
      imageAvailability = false;
      image = Image.asset('assets/small_circles/' + 'no_image' + '.webp');

      imageData = (await rootBundle.load('assets/small_circles/' + 'no_image' + '.webp'))
          .buffer
          .asUint8List();

    }

    // try {
    //   final bundle = DefaultAssetBundle.of(context);
    //   await bundle.load(imagePath);
    //   // print('we have this image');
    // } catch (e) {
    //   // print('no image');
    // }

  // print(image);

    Circle circle = new Circle();
    circle.name = name;
    circle.year = year;
    circle.realName = realName;
    circle.image = image;
    circle.imageAvailability = imageAvailability;
    circle.imageData = imageData;

    circles.add(circle);

    for(String i in years) {
      if (!distinctYears.contains(i)) {
        distinctYears.add(i);
      }
    }

    // print(distinctYears);

    loaded = (namesAndYearsList.indexOf(s) + 1) / namesAndYearsList.length;

  }

  // return circles;

  // print("imageAvailability is: " + imageAvailability.toString());

  // print('names length is: ' + namesList.length.toString());
  // // print(namesList);
  // print('yearsList length is: ' + yearsList.length.toString());
  // // print(yearsList);
  //
  // var temp = namesList[100].split(" ").first;
  // print(temp);



}