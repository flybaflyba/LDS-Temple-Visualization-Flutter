
import 'dart:typed_data';

import 'package:flutter/material.dart';

class Circle {
  double x;
  double y;
  double size;
  // Image image;
  String name;
  String realName;
  String year;
  bool imageAvailability;
  bool onScreen;
  Uint8List imageData = null;
  String order;
  Uint8List largeImageData;
  bool largeImageDataLoadingStatus = false;

  double sizeS;
  double positionS;


  Circle();

}

