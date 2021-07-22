import 'dart:math';

import 'package:spiral_vis/Circle.dart';
import 'package:spiral_vis/Universals.dart';


void getCoordinatesAndSizes() {

  coordinatesAndSizes.clear();
  // print('clear');

  double initialRadius = 0.1;
  double centerX = 0.57;
  double centerY = 0.5;

  // List<List<double>> coordinatesAndSizes = <List<double>>[];

  for (double i = -28.0; i < 17.5; i += 0.02) {
    double x = centerX + initialRadius * (exp(i * 1 / (tan(47 * pi / 100)))) * (cos(i));
    double y = centerY + initialRadius * (exp(i * 1 / (tan(47 * pi / 100)))) * (sin(i));

    double xNew = 0;
    double yNew = 0;

    int angle = theta;

    if (spiralStyle == "Spin") {
      angle = (theta / 100).toInt();
      xNew = (x - centerX) * cos(angle) - (y - centerY) * sin(angle) + centerX;
      yNew = (y - centerY) * cos(angle) + (x - centerX) * sin(angle) + centerY;
    } else if (spiralStyle == "3D") {
      angle = (theta / 500).toInt();
      xNew = (x - centerX) * cos(angle) - (y - centerY) * sin(angle) + centerX;
      yNew = (y - centerY) * cos(angle) + (xNew - centerX) * sin(angle) + centerY;
    } else {
      xNew = x;
      yNew = y;
    }


    double i2 = i - 2 * pi;
    double x2 = centerX + initialRadius * (exp(i2 * 1 / (tan(47 * pi / 100)))) * (cos(i2));
    double y2 = centerY + initialRadius * (exp(i2 * 1 / (tan(47 * pi / 100)))) * (sin(i2));

    double size = (sqrt(pow((x - x2).abs(), 2) + pow((y - y2).abs(), 2)));
    // size = (size / screenWidth * 1.3f);

    List<double> temp = [xNew, yNew, size];
    coordinatesAndSizes.add(temp);

  }



  double topCoordinateX = coordinatesAndSizes.last[0];
  double topCoordinateY = coordinatesAndSizes.last[1];
  double topSize = coordinatesAndSizes.last[2];

  if (spiralStyle == "Default") {

    for (double i = 0; i < 70; i += 1) {
      List<double> temp = [];
      temp.add(topCoordinateX + i * 0.01);
      temp.add(topCoordinateY);
      temp.add(topSize);
      coordinatesAndSizes.add(temp);
    }
  } else {

    double secondTopCoordinateInSpiralX = coordinatesAndSizes[(coordinatesAndSizes.length-2)][0];
    double secondTopCoordinateInSpiralY = coordinatesAndSizes[(coordinatesAndSizes.length-2)][1];
    double xDirection = topCoordinateX - secondTopCoordinateInSpiralX;
    double yDirection = topCoordinateY - secondTopCoordinateInSpiralY;

    for (double i = 0; i < 70; i += 1) {
      double step = i * 0.0075;
      List<double> temp = [];
      temp.add(xDirection / xDirection.abs() * step + secondTopCoordinateInSpiralX);
      temp.add(yDirection / yDirection.abs() * step + secondTopCoordinateInSpiralY);
      temp.add(topSize);
      coordinatesAndSizes.add(temp);
    }

  }

}

void placeCircles(int theta) {

  // no need to do again if spiral style is set to default.
  // do need to do again if spiral style is set to not default.

  if(spiralStyle != 'Default' || firstTime) {
    getCoordinatesAndSizes();
    firstTime = false;
  }

  // print(coordinatesAndSizes.length.toString());

  for (Circle c in circles) {

    int circleIndexInCoordinatesAndSizes = theta - 30 * circles.indexOf(c);
    if (circleIndexInCoordinatesAndSizes >= 0 && circleIndexInCoordinatesAndSizes < coordinatesAndSizes.length) {
      c.x = coordinatesAndSizes[circleIndexInCoordinatesAndSizes][0];
      c.y = coordinatesAndSizes[circleIndexInCoordinatesAndSizes][1];
      c.size = coordinatesAndSizes[circleIndexInCoordinatesAndSizes][2];
      c.onScreen = true;
    }
    else if (circleIndexInCoordinatesAndSizes < 0){
      c.x = 0.57; // coordinatesAndSizes.first[0];
      c.y = 0.5; // coordinatesAndSizes.first[1];
      c.size = 0.005;
      c.onScreen = false;
    } else if (circleIndexInCoordinatesAndSizes >= coordinatesAndSizes.length - 1) {
      c.x = coordinatesAndSizes.last[0];
      c.y = coordinatesAndSizes.last[1];
      c.size = coordinatesAndSizes.last[2];
      c.onScreen = false;

      // get on screen temple years
      startYear = c.year;
      int circleIndex = circles.indexOf(c);
      endYear = circles[(circleIndex + 30) < circles.length ? circleIndex + 30 : circles.length - 1].year;

      if(startYear == '0000'){
        startYear = 'Construction';
      } else if(startYear == '1111'){
        startYear = 'Announced';
      }

      if(endYear == '0000'){
        endYear = 'Construction';
      } else if(endYear == '1111'){
        endYear = 'Announced';
      }

      // print(startYear + " " + endYear);

    }
  }

  // return circles;
}


