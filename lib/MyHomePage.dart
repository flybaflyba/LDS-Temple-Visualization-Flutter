
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'dart:ui';

import 'package:spiral_vis/Caculation.dart';
import 'package:spiral_vis/Circle.dart';
import 'package:spiral_vis/Loader.dart';

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

  List<Circle> circles = [];

  Future<void> prepareCircles() async {

      circles = await loadImages(context);

  }

  int theta = 7000;


  @override
  void initState() {
    super.initState();

    coordinatesAndSizes = getCoordinatesAndSizes();


      prepareCircles().then((value) {
        print('finish loading assets');
        setState(() {
          circles = placeCircles(coordinatesAndSizes, circles, theta);
        });

      });




  }

  void spin(int speed){
    setState(() {
      theta = (theta + speed * 0.5).toInt();
      circles = placeCircles(coordinatesAndSizes, circles, theta);
    });
  }


  Stack buildSpiral(BoxConstraints constraints) {

    // print(constraints.maxWidth);
    // print(constraints.maxHeight);

    List<AnimatedPositioned> elements = [];

    double specialSizeRatio = 1.33;

    // print('circles.length: ' + circles.length.toString());




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
          // top: constraints.maxWidth / 2 + 100,
          // left: constraints.maxWidth / 2 ,
          // left: w/2,
          width: size * constraints.maxWidth * specialSizeRatio,
          height: size * constraints.maxWidth * specialSizeRatio,
          child:

          GestureDetector(
            onTap: () {
              setState(() {
                print('tapped: ' + realName);
              });
            },
            onPanUpdate: (DragUpdateDetails details) {
              double x = details.globalPosition.dx;
              double y = details.globalPosition.dy;

              // print(details.globalPosition.dx.toString() + ", " + details.globalPosition.dy.toString());



              if(x <= constraints.maxWidth * (1/3)) {
                print('at left');
                // if(details.delta.dy > 0){
                //   antiClockwiseSpin();
                // } else if (details.delta.dy < 0){
                //   clockwiseSpin();
                // }
                spin(-details.delta.dy.toInt());
              } else if (x >= constraints.maxWidth * (2/3)) {
                print('at right');
                // if(details.delta.dy < 0){
                //   antiClockwiseSpin();
                // } else if (details.delta.dy > 0){
                //   clockwiseSpin();
                // }
                spin(details.delta.dy.toInt());
              } else {
                print('at middle');
                if(y <= constraints.maxHeight * (1/3)){
                  print('top');
                  // if(details.delta.dx < 0){
                  //   antiClockwiseSpin();
                  // } else if (details.delta.dx > 0){
                  //   clockwiseSpin();
                  // }
                  spin(details.delta.dx.toInt());
                } else if(y >= constraints.maxHeight * (2/3)){
                  print('bottom');
                  // if(details.delta.dx > 0){
                  //   antiClockwiseSpin();
                  // } else if (details.delta.dx < 0){
                  //   clockwiseSpin();
                  // }
                  spin(-details.delta.dx.toInt());
                }
              }

            },
            child: Container(
              // color: Colors.black,
              child:
              image,
              // CircleAvatar(backgroundColor: Colors.red,),

            ),

          // Image.asset('assets/images/laie_hawaii_temple_large.webp'),
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
          label: theta.toDouble().round().toString(),
          onChanged: (value) {
            theta = value.toInt();
            setState(() {
              circles = placeCircles(coordinatesAndSizes, circles, theta);
            }
            );
          },
        ),
      ),



      // Slider(
      //   value: theta.toDouble(),
      //   min: 0,
      //   max: 9000,
      //   divisions: 9000,
      //   label: theta.toDouble().round().toString(),
      //   onChanged: (double value) {
      //     setState(() {
      //       theta = value.toInt();
      //       setState(() {
      //         circles = placeCircles(coordinatesAndSizes, circles, theta);
      //       });
      //     });
      //   },
      // )
    );

    elements.add(slider);

    AnimatedPositioned leftButton = AnimatedPositioned(
      duration: Duration(milliseconds: 0),
      bottom: constraints.maxHeight * 0.07,
      left: constraints.maxWidth * 0.01,
      // right: constraints.maxWidth * 0.9,
      child: IconButton(
        icon: const Icon(Icons.arrow_left_sharp),
        color: Colors.blue,
        iconSize: constraints.maxWidth * 0.1,
        tooltip: 'Anticlockwise spinning',
        onPressed: () {
          setState(() {
            if(theta >= 2240 + 30) {
              theta = theta - 30;
              circles = placeCircles(coordinatesAndSizes, circles, theta);
            }
          });
        },
      ),
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
              circles = placeCircles(coordinatesAndSizes, circles, theta);
            }
          });
        },
      ),
    );

    elements.add(leftButton);
    elements.add(rightButton);

    // print('elements.length: ' + elements.length.toString());

    // for(List<Circle> circle in circles) {
    //   Positioned point = Positioned(
    //       top: i[1] * constraints.maxWidth - (i[2] * constraints.maxWidth * specialSizeRatio) / 2 + 100,
    //       left: i[0] * constraints.maxWidth - (i[2] * constraints.maxWidth * specialSizeRatio) / 2 ,
    //       // top: constraints.maxWidth / 2 + 100,
    //       // left: constraints.maxWidth / 2 ,
    //       // left: w/2,
    //       child: Container(
    //         width: i[2] * constraints.maxWidth * specialSizeRatio,
    //         height: i[2] * constraints.maxWidth * specialSizeRatio,
    //         // color: Colors.black,
    //         child:
    //         CircleAvatar(backgroundColor: Colors.red,),
    //         // Image.asset('assets/images/laie_hawaii_temple_large.webp'),
    //       )
    //   );
    //
    //   elements.add(point);
    //
    // }

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
          TextButton(
            onPressed: () {
             print('update test');
             setState(() {
               theta = theta + 100;
               circles = placeCircles(coordinatesAndSizes, circles, theta);
             });
            },
            child: const Text('button', style: TextStyle(color: Colors.red),),
          ),
        ],
      ),
      body: LayoutBuilder (
        builder: (context, constraints) {
          return
            buildSpiral(constraints);


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
