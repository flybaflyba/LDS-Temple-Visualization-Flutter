

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
    years.add(year);

    String imagePath = 'assets/images/' + name + '_large.webp';

    Image image;
    try {
      final bundle = DefaultAssetBundle.of(context);
      await bundle.load(imagePath);
      // print('we have this image');
      imageAvailability = true;
      image = Image.asset(
        imagePath,
        fit: BoxFit.cover,
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

    } catch (e) {
      image = Image.asset('assets/images/' + 'no_image' + '_large.webp');
      // print('no image');
      imageAvailability = false;
    }
  // print(image);

    Circle circle = new Circle();
    circle.name = name;
    circle.year = year;
    circle.realName = realName;
    circle.image = image;
    circle.imageAvailability = imageAvailability;

    circles.add(circle);

    for(String i in years) {
      if (!distinctYears.contains(i)) {
        distinctYears.add(i);
      }
    }

    // print(distinctYears);

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