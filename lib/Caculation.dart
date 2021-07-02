import 'dart:math';

import 'package:spiral_vis/Circle.dart';


List<List<double>> getCoordinatesAndSizes() {
    double initialRadius = 0.1;
    double centerX = 0.5;
    double centerY = 0.5;

    List<List<double>> coordinatesAndSizes = <List<double>>[];

    for (double i = -18.0; i < 17.5; i += 0.02) {
      double x = centerX + initialRadius * (exp(i * 1 / (tan(47 * pi / 100)))) * (cos(i));
      double y = centerY + initialRadius * (exp(i * 1 / (tan(47 * pi / 100)))) * (sin(i));

      double i2 = i - 2 * pi;
      double x2 = centerX + initialRadius * (exp(i2 * 1 / (tan(47 * pi / 100)))) * (cos(i2));
      double y2 = centerY + initialRadius * (exp(i2 * 1 / (tan(47 * pi / 100)))) * (sin(i2));

      double size = (sqrt(pow((x - x2).abs(), 2) + pow((y - y2).abs(), 2)));
      // size = (size / screenWidth * 1.3f);

      List<double> temp = [x, y, size];
      coordinatesAndSizes.add(temp);

    }

    double topCoordinateX = coordinatesAndSizes.last[0];
    double topCoordinateY = coordinatesAndSizes.last[1];
    double topSize = coordinatesAndSizes.last[2];

    for (double i = 0; i < 70; i += 1) {
      List<double> temp = [];
      temp.add(topCoordinateX + i * 0.01);
      temp.add(topCoordinateY);
      temp.add(topSize);
      coordinatesAndSizes.add(temp);
    }

    return coordinatesAndSizes;

  }

List<Circle> placeCircles(List<List<double>> coordinatesAndSizes, List<Circle> circles, int theta) {

  for (Circle c in circles) {
    int circleIndex = circles.indexOf(c);
    int circleIndexInCoordinatesAndSizes = theta - 30 * circles.indexOf(c);
    if (circleIndexInCoordinatesAndSizes >= 0 && circleIndexInCoordinatesAndSizes < coordinatesAndSizes.length) {
      c.x = coordinatesAndSizes[circleIndexInCoordinatesAndSizes][0];
      c.y = coordinatesAndSizes[circleIndexInCoordinatesAndSizes][1];
      c.size = coordinatesAndSizes[circleIndexInCoordinatesAndSizes][2];
    }
    else if (circleIndexInCoordinatesAndSizes < 0){
      c.x = 0.503;
      c.y = 0.5;
      c.size = 0.025;
    } else if (circleIndexInCoordinatesAndSizes >= coordinatesAndSizes.length - 1) {
      c.x = coordinatesAndSizes.last[0];
      c.y = coordinatesAndSizes.last[1];
      c.size = coordinatesAndSizes.last[2];
    }
  }

  return circles;
}


