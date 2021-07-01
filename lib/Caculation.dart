import 'dart:math';


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


