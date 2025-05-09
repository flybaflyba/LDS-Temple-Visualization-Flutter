import 'dart:typed_data';

import 'package:flutter/material.dart';

class Circle {
  double x = 0.0;
  double y = 0.0;
  double size = 0.0;
  // Image image;
  String name = '';
  String realName = '';
  String year = '';
  bool imageAvailability = false;
  bool onScreen = false;
  Uint8List imageData = Uint8List(0);
  String order = '';
  Uint8List largeImageData = Uint8List(0);
  bool largeImageDataLoadingStatus = false;

  double sizeS = 0.0;
  double positionS = 0.0;

  Circle({
    this.x = 0.0,
    this.y = 0.0,
    this.size = 0.0,
    this.name = '',
    this.realName = '',
    this.year = '',
    this.imageAvailability = false,
    this.onScreen = false,
    Uint8List? imageData,
    this.order = '',
    Uint8List? largeImageData,
    this.largeImageDataLoadingStatus = false,
    this.sizeS = 0.0,
    this.positionS = 0.0,
  }) {
    this.imageData = imageData ?? Uint8List(0);
    this.largeImageData = largeImageData ?? Uint8List(0);
  }
}

