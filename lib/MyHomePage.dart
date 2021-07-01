
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'dart:ui';

import 'package:spiral_vis/Caculation.dart';
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


  @override
  void initState() {
    super.initState();

    coordinatesAndSizes = getCoordinatesAndSizes();

  }

  Stack buildSpiral(BoxConstraints constraints) {

    print(constraints.maxWidth);
    print(constraints.maxHeight);

    List<Positioned> points = [];

    double specialSizeRatio = 1.25;

    for(List<double> i in coordinatesAndSizes) {
      Positioned point = Positioned(
          top: i[1] * constraints.maxWidth - (i[2] * constraints.maxWidth * specialSizeRatio) / 2 + 100,
          left: i[0] * constraints.maxWidth - (i[2] * constraints.maxWidth * specialSizeRatio) / 2 ,
          // top: constraints.maxWidth / 2 + 100,
          // left: constraints.maxWidth / 2 ,
          // left: w/2,
          child: Container(
            width: i[2] * constraints.maxWidth * specialSizeRatio,
            height: i[2] * constraints.maxWidth * specialSizeRatio,
            // color: Colors.black,
            child:
            CircleAvatar(backgroundColor: Colors.red,),
            // Image.asset('assets/images/laie_hawaii_temple_large.webp'),
          )
      );

      points.add(point);

    }

    Stack stack = Stack(children: points,);

    print('coordinates and sizes length: ' + coordinatesAndSizes.length.toString());
    print('stack children length: ' + stack.children.length.toString());

    return stack;
  }


  @override
  Widget build(BuildContext context) {

    // getCoordinatesAndSizes();

    loadImages();

    return
      Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [

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
