import 'dart:math';


List<List<double>> getCoordinatesAndSizes() {
    double initialRadius = 0.1;
    double centerX = 0.5;
    double centerY = 0.5;

    List<List<double>> coordinatesAndSizes = <List<double>>[];

    for (double i = -18.0; i < 17.5; i += 0.02) {
      double x = centerX + initialRadius * (exp(i * 1 / (tan(47 * pi / 100)))) * (cos(i));
      double y = centerY + initialRadius * (exp(i * 1 / (tan(47 * pi / 100)))) * (sin(i));

      List<double> temp = [x, y];
      coordinatesAndSizes.add(temp);
    }

    double topCoordinateX = coordinatesAndSizes.last.first;
    double topCoordinateY = coordinatesAndSizes.last.last;

    for (double i = 0; i < 70; i += 1) {
      List<double> temp = [];
      temp.add(topCoordinateX + i * 0.01);
      temp.add(topCoordinateY);
      coordinatesAndSizes.add(temp);
    }

    print('hi');

    print(coordinatesAndSizes.length);

    return coordinatesAndSizes;

  }


