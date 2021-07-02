
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:spiral_vis/About.dart';
// import 'dart:ui';

import 'package:spiral_vis/Caculation.dart';
import 'package:spiral_vis/Circle.dart';
import 'package:spiral_vis/Loader.dart';
import 'package:spiral_vis/SingleView.dart';
import 'package:spiral_vis/Universals.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // var w = window.physicalSize.width;
  // var h = window.physicalSize.height;

  var large = true;

  var sampleW = 100.0;

  List<List<double>> coordinatesAndSizes =[];

  Future<void> prepareCircles() async {
      await loadImages(context);
  }

  bool showYearsRange = true;

  @override
  void initState() {
    super.initState();

    coordinatesAndSizes = getCoordinatesAndSizes();

    prepareCircles().then((value) {
      print('finish loading assets');
      setState(() {
        placeCircles(coordinatesAndSizes, theta);
      });
    });
  }

  void spin(int speed){
    setState(() {
      theta = (theta + speed * 0.5).toInt();
      placeCircles(coordinatesAndSizes, theta);
    });
  }


  Stack buildLayout(BoxConstraints constraints) {

    // print(constraints.maxWidth);
    // print(constraints.maxHeight);

    List<AnimatedPositioned> elements = [];

    double specialSizeRatio = 1.33;

    for(int i = 0; i < circles.length; i++){
      double x = circles[i].x == null ? 0 : circles[i].x;
      double y = circles[i].y == null ? 0 : circles[i].y;
      double size = circles[i].size  == null ? 0 : circles[i].size;
      Image image = circles[i].image  == null ? 0 : circles[i].image;
      String realName = circles[i].realName  == null ? 'no name' : circles[i].realName;
      // print('$x, $y, $size');
      // print(circles[i].image);
      AnimatedPositioned point = AnimatedPositioned(
        duration: Duration(milliseconds: 500),
          top: y * constraints.maxWidth - (size * constraints.maxWidth * specialSizeRatio) / 2 + constraints.maxHeight * 0.1,
          left: x * constraints.maxWidth - (size * constraints.maxWidth * specialSizeRatio) / 2,
          width: size * constraints.maxWidth * specialSizeRatio,
          height: size * constraints.maxWidth * specialSizeRatio,
          child: GestureDetector(
            onTap: () {
              setState(() {
                print('tapped $realName');
                // Navigator.pushNamed(context, '/SingleView');
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SingleView(circle: circles[i],)));
              });
            },
            onPanUpdate: (DragUpdateDetails details) {
              double x = details.globalPosition.dx;
              double y = details.globalPosition.dy;

              if(x <= constraints.maxWidth * (1/3)) {
                // print('at left');
                spin(-details.delta.dy.toInt());
              } else if (x >= constraints.maxWidth * (2/3)) {
                // print('at right');
                spin(details.delta.dy.toInt());
              } else {
                // print('at middle');
                if(y <= constraints.maxHeight * (1/3)){
                  // print('top');
                  spin(details.delta.dx.toInt());
                } else if(y >= constraints.maxHeight * (2/3)){
                  // print('bottom');
                  spin(-details.delta.dx.toInt());
                }
              }
            },
            child: Container(
              child: image,
            ),
          )
      );
      elements.add(point);
    }


    AnimatedPositioned slider = AnimatedPositioned(
      duration: Duration(milliseconds: 0),
      bottom: constraints.maxHeight * 0.07,
      right: constraints.maxWidth * 0.1,
      left: constraints.maxWidth * 0.1,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: Colors.blue[700],
          inactiveTrackColor: Colors.blue[100],
          trackShape: RoundedRectSliderTrackShape(),
          trackHeight: 4.0,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
          thumbColor: Colors.blueAccent,
          overlayColor: Colors.blue.withAlpha(32),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
          tickMarkShape: RoundSliderTickMarkShape(),
          activeTickMarkColor: Colors.blue[700],
          inactiveTickMarkColor: Colors.blue[100],
          valueIndicatorShape: PaddleSliderValueIndicatorShape(),
          valueIndicatorColor: Colors.blueAccent,
          valueIndicatorTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        child: Slider(
          value: theta.toDouble(),
          min: 2240,
          max: 9820,
          divisions: 9820 - 2240,
          label: '$startYear - $endYear',
          onChangeStart: (value) {
            setState(() {
              showYearsRange = false;
            });
          },
          onChangeEnd: (value) {
            setState(() {
              showYearsRange = true;
            });
          },
          onChanged: (value) {
            theta = value.toInt();
            setState(() {
              placeCircles(coordinatesAndSizes, theta);
            }
            );
          },
        ),
      ),
    );

    elements.add(slider);

    AnimatedPositioned leftButton = AnimatedPositioned(
      duration: Duration(milliseconds: 0),
      bottom: constraints.maxHeight * 0.07,
      left: constraints.maxWidth * 0.01,
      // right: constraints.maxWidth * 0.9,
      child: Container(
        child: IconButton(
          icon: const Icon(Icons.arrow_left_sharp),
          color: Colors.blue,
          iconSize: constraints.maxWidth * 0.1,
          tooltip: 'Anticlockwise spinning',
          onPressed: () {
            setState(() {
              if(theta >= 2240 + 30) {
                theta = theta - 30;
                placeCircles(coordinatesAndSizes, theta);
              }
            });
          },
        ),
      )
    );

    AnimatedPositioned rightButton = AnimatedPositioned(
      duration: Duration(milliseconds: 0),
      bottom: constraints.maxHeight * 0.07,
      // left: constraints.maxWidth * 0.9,
      right: constraints.maxWidth * 0.01,
      child: IconButton(
        icon: const Icon(Icons.arrow_right_sharp),
        color: Colors.blue,
        iconSize: constraints.maxWidth * 0.1,
        tooltip: 'Anticlockwise spinning',
        onPressed: () {
          setState(() {
            if(theta <= 9820 - 30) {
              theta = theta + 30;
              placeCircles(coordinatesAndSizes, theta);
            }
          });
        },
      ),
    );

    elements.add(leftButton);
    elements.add(rightButton);

    AnimatedPositioned yearRange = AnimatedPositioned(
      duration: Duration(milliseconds: 0),
      bottom: constraints.maxHeight * 0.15,
      left: constraints.maxWidth * 0.1,
      right: constraints.maxWidth * 0.1,
      child: Container(
        child: AnimatedDefaultTextStyle(
          child: Text('$startYear - $endYear', textAlign: TextAlign.center,),
          style : showYearsRange ? TextStyle(
            color: Colors.blue,
            fontSize: 20,
          ) : TextStyle(
            color: Colors.grey,
            fontSize: 0,
          ),
          duration: Duration(milliseconds: 500),
        ),

      ),
    );

    elements.add(yearRange);

    // print('elements.length: ' + elements.length.toString());

    Stack stack = Stack(children: elements,);

    // print('coordinates and sizes length: ' + coordinatesAndSizes.length.toString());
    // print('stack children length: ' + stack.children.length.toString());

    return stack;
  }


  @override
  Widget build(BuildContext context) {


    // circles = placeCircles(coordinatesAndSizes, circles, 8000);

    // getCoordinatesAndSizes();

    // loadImages(context);

    // placeCircles(coordinatesAndSizes, circles, 0);

    return
      Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            color: Colors.lightBlueAccent,
            tooltip: 'Anticlockwise spinning',
            onPressed: () {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('About Temples Timeline'),
                    content: about,
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),

        ],
      ),
      body: LayoutBuilder (
        builder: (context, constraints) {
          return
            buildLayout(constraints);


            Stack(
            children: [
              Positioned(
                top: 0.2 * constraints.maxHeight,
                left: 0.2 * constraints.maxWidth,
                // left: w/2,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 1000),
                  color: Colors.red,
                  width: sampleW,
                  child: Image.asset(
                    "assets/images/laie_hawaii_temple_large.webp",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Positioned(
                top: 0.1 * constraints.maxHeight,
                // bottom: 0.2 * constraints.maxHeight,
                left: 0.1 * constraints.maxWidth,
                // right: 0.2 * constraints.maxWidth,
                // left: w/2,
                child: TextButton(
                  onPressed: () {
                    // print(w);
                    // print(h);
                    print(constraints.maxWidth);
                    print(constraints.maxHeight);
                    print(coordinatesAndSizes.length);
                    print(coordinatesAndSizes);
                    setState(() {
                      large = !large;
                      sampleW = sampleW + 100;
                    });
                  },
                  child: const Text('button', style: TextStyle(color: Colors.red),),
                ),
              ),



            ],
          );
        }

      ),


     // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
