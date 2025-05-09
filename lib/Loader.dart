import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spiral_vis/Circle.dart';
import 'package:spiral_vis/Universals.dart';

Future<List<String>> readNamesAndYearsFile() async {
  String namesAndYearsText = await rootBundle.loadString('assets/texts/names_and_years.txt');
  List<String> namesAndYearsList = namesAndYearsText.split('\n');
  return namesAndYearsList.reversed.toList();
}

Future<void> loadCircles(BuildContext context) async {
  // List<Circle> circles = [];
  List<String> namesAndYearsList = await readNamesAndYearsFile();

  // List<String> namesList = [];
  // List<String> yearsList = [];



  // bool imageAvailability;

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


    bool imageAvailability;
    String imagePath = 'assets/small_circles/' + name + '.webp';

    final manifestJson = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final imagesInAssets = json.decode(manifestJson).keys.where((String key) => key.startsWith('assets/small_circles'));
    // print(imagesInAssets);

    if(imagesInAssets.contains(imagePath)) {
      // print('we have this image');
      imageAvailability = true;
    } else {
      // print('missing image');
      imageAvailability = false;
    }



    // Create circle with proper initialization
    Circle circle = new Circle(
      name: name,
      year: year,
      realName: realName,
      imageAvailability: imageAvailability
    );
    
    circles.add(circle);

    for(String i in years) {
      if (!distinctYears.contains(i)) {
        distinctYears.add(i);
      }
    }

    // print(distinctYears);

  }


  circles = circles.reversed.toList();

  years = years.reversed.toList();
  names = names.reversed.toList();


  noOfCircles = circles.length;

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

Future<void> loadImages(BuildContext context) async {

  print('loading images');

  for (Circle c in circles) {

    Future.delayed(Duration(milliseconds: 1), () async {
      String name = c.name;
      String imagePath = 'assets/small_circles/' + name + '.webp';
      Uint8List imageData;
      // print(imagePath);
      if(c.imageAvailability){
        imageData = (await rootBundle.load(imagePath))
          .buffer
          .asUint8List();
      } else {
      imageData = (await rootBundle.load('assets/small_circles/' + 'no_image' + '.webp'))
          .buffer
          .asUint8List();
      }
      c.imageData = imageData;

      // print('loaded image of ' + name);
    });



    // loaded = (circles.indexOf(c) + 1) / circles.length;
  }





  // try {
  //   final bundle = DefaultAssetBundle.of(context);
  //   await bundle.load(imagePath);
  //   // print('we have this image');
  // } catch (e) {
  //   // print('no image');
  // }

  // print(image);

}