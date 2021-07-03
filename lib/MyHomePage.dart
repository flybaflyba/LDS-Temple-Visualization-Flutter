
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_material_pickers/helpers/show_responsive_dialog.dart';
import 'package:flutter_material_pickers/helpers/show_scroll_picker.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:spiral_vis/About.dart';
// import 'dart:ui';

import 'package:spiral_vis/Caculation.dart';
import 'package:spiral_vis/Circle.dart';
import 'package:spiral_vis/Loader.dart';
import 'package:spiral_vis/SearchByName.dart';
import 'package:spiral_vis/Settings.dart';
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



  Future<void> prepareCircles() async {
      await loadImages(context);
  }

  bool showYearsRange = true;

  @override
  void initState() {
    super.initState();

    loadingAssets = true;

    getCoordinatesAndSizes();

    prepareCircles().then((value) {
      print('finish loading assets');
      setState(() {
        loadingAssets = false;
        placeCircles(coordinatesAndSizes, theta);
      });
    });


  }

  void spin(int speed){
    setState(() {
      if ((theta + speed * 0.5).toInt() >= 2240 && (theta + speed * 0.5).toInt() <= 9820) {
        theta = (theta + speed * 0.5).toInt();
        placeCircles(coordinatesAndSizes, theta);
      }
    });
  }


  Stack buildLayout(BoxConstraints constraints) {

    double magicNumber = min(constraints.maxWidth, constraints.maxHeight);

    double magicNumberAnother = magicNumber;

    bool portrait = true;

    if (MediaQuery.of(context).orientation == Orientation.portrait){
      // is portrait
      print('portrait');
      portrait = true;
    }else{
      // is landscape
      print('landscape');
      portrait = false;
      magicNumberAnother = max(constraints.maxWidth, constraints.maxHeight);

      magicNumber = min(constraints.maxWidth, constraints.maxHeight) * 0.75;
    }

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
      bool onScreen = circles[i].onScreen  == null ? false : circles[i].onScreen;
      // print('$x, $y, $size');
      // print(circles[i].image);
      AnimatedPositioned point = AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          top: y * magicNumber - (size * magicNumber * specialSizeRatio) / 2 + constraints.maxHeight * (portrait ? 0.15 : 0.1),
          left: x * magicNumber - (size * magicNumber * specialSizeRatio) / 2 + (magicNumberAnother - magicNumber) / 2,
          width: size * magicNumber * specialSizeRatio,
          height: size * magicNumber * specialSizeRatio,
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
              child:

              !onScreen
                  ?
              Container()
                  :
              Stack(
                children: [
                  Container(
                    // color: Colors.blue,
                    child: image,
                  ),

                  (searchedCircleIndexes.contains(i))
                      ?
                  Container(
                    // color: Colors.red,
                    constraints: BoxConstraints(
                      minWidth: size * magicNumber * specialSizeRatio,
                      minHeight: size * magicNumber * specialSizeRatio,
                      maxWidth: size * magicNumber * specialSizeRatio,
                      maxHeight: size * magicNumber * specialSizeRatio,
                    ),
                    child:  Container(
                      // color: Colors.red,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100),),
                        border: Border.all(
                          width: 5,
                          color: Colors.green,
                          style: BorderStyle.solid,
                        ),
                      ),
                      constraints: BoxConstraints(
                        minWidth: size * magicNumber * specialSizeRatio * 0.8,
                        minHeight: size * magicNumber * specialSizeRatio * 0.8,
                        maxWidth: size * magicNumber * specialSizeRatio * 0.8,
                        maxHeight: size * magicNumber * specialSizeRatio * 0.8,
                      ),
                    ),
                  )
                      :
                  Container(),

                  (!circles[i].imageAvailability && size > 0.15 && size < circles.first.size)
                      ?
                  Container(
                    // color: Colors.red,
                    constraints: BoxConstraints(
                      minWidth: size * magicNumber * specialSizeRatio,
                      minHeight: size * magicNumber * specialSizeRatio,
                      maxWidth: size * magicNumber * specialSizeRatio,
                      maxHeight: size * magicNumber * specialSizeRatio,
                    ),
                    child:  Container(
                      // color: Colors.red,
                        constraints: BoxConstraints(
                          minWidth: size * magicNumber * specialSizeRatio * 0.8,
                          minHeight: size * magicNumber * specialSizeRatio * 0.8,
                          maxWidth: size * magicNumber * specialSizeRatio * 0.8,
                          maxHeight: size * magicNumber * specialSizeRatio * 0.8,
                        ),
                        child: Center(
                          child: Text(
                            realName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 8.0,
                                  color: Color.fromARGB(125, 0, 0, 255),
                                ),
                              ],
                            ),
                          ),
                        )
                    ),
                  )
                      :
                  Container(),

                  (showLabel && circles[i].imageAvailability && size > 0.15 && (size < circles.first.size || realName != 'Kirtland Temple'))
                      ?
                  Container(
                    // color: Colors.red,
                    constraints: BoxConstraints(
                      minWidth: size * magicNumber * specialSizeRatio,
                      minHeight: size * magicNumber * specialSizeRatio,
                      maxWidth: size * magicNumber * specialSizeRatio,
                      maxHeight: size * magicNumber * specialSizeRatio,
                    ),
                    child: Container(
                      // color: Colors.red,
                        constraints: BoxConstraints(
                          minWidth: size * magicNumber * specialSizeRatio * 0.8,
                          minHeight: size * magicNumber * specialSizeRatio * 0.8,
                          maxWidth: size * magicNumber * specialSizeRatio * 0.8,
                          maxHeight: size * magicNumber * specialSizeRatio * 0.8,
                        ),
                        child: Center(
                            child: Container(
                              alignment: Alignment(0.0, 0.9),
                              child: Text(
                                realName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 3.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 8.0,
                                      color: Color.fromARGB(125, 0, 0, 255),
                                    ),
                                  ],
                                ),
                              ),
                            )



                        )
                    ),
                  )
                      :
                  Container(),




                ],
              )
          )
      );
      elements.add(point);
    }

    AnimatedPositioned bottom = AnimatedPositioned(
      duration: Duration(milliseconds: 0),
      bottom: constraints.maxHeight * 0.08,
      left: constraints.maxWidth * 0.05,
      right: constraints.maxWidth * 0.05,
      child: Center(
        child: Wrap(
          children: [
            Column(
              children: [
                Container(
                  child:
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          // color: Colors.red,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.chevron_left),
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


                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          // color: Colors.green,
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
                        )
                      ),
                      Expanded(
                          flex: 1,
                          child: Container(
                            // color: Colors.red,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.chevron_right),
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
                          )
                      )
                    ],
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(117, 107, 97, 0.5),
                        border: Border.all(
                          color: Color.fromRGBO(117, 107, 97, 0.5),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    // color: Color.fromRGBO(117, 107, 97, 0.5),
                    child: Container(
                      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      child: AnimatedDefaultTextStyle(
                        child: Text('$startYear - $endYear', textAlign: TextAlign.center,),
                        style : showYearsRange ? TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                        ) : TextStyle(
                          color: Colors.grey,
                          fontSize: 1,
                        ),
                        duration: Duration(milliseconds: 500),
                      ),
                    )
                ),
              ],
            )

          ],
        ),
      ),
    );

    elements.add(bottom);

    // print('elements.length: ' + elements.length.toString());

    Stack stack = Stack(children: elements,);

    // print('coordinates and sizes length: ' + coordinatesAndSizes.length.toString());
    // print('stack children length: ' + stack.children.length.toString());

    return stack;
  }

  bool showLabel = false;

  String selectedYear;

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
          // IconButton(
          //     icon: const Icon(Icons.settings),
          //     color: Colors.lightBlueAccent,
          //     tooltip: 'Settings',
          //     onPressed: () {
          //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => Settings(),));
          //     }
          // ),
    ],
      ),
      body: loadingAssets
          ?
      Center(
        child: LiquidCircularProgressIndicator(
          value: 0.65, // Defaults to 0.5.
          valueColor: AlwaysStoppedAnimation(Colors.pink), // Defaults to the current Theme's accentColor.
          backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
          borderColor: Colors.red,
          borderWidth: 5.0,
          direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
          center: Text("Loading..."),
        ),
      )
          :
      LayoutBuilder (
          builder: (context, constraints) {
            return buildLayout(constraints);
          }
      ),

        floatingActionButton: SpeedDial(
          child: const Icon(Icons.add),
          speedDialChildren: <SpeedDialChild>[
            SpeedDialChild(
              child: const Icon(Icons.calendar_today),
              foregroundColor: Colors.blue,
              backgroundColor: Colors.greenAccent,
              label: 'Pick a Year',
              onPressed: () {

                print(distinctYears);

                showMaterialScrollPicker<String>(
                  backgroundColor: Colors.white,
                  context: context,
                  title: 'Pick a Year',
                  items: distinctYears,
                  selectedItem: selectedYear,
                  showDivider: false,
                  onChanged: (value) => setState(() => selectedYear = value),
                  onCancelled: () {

                  },
                  onConfirmed: () {
                    print(selectedYear);

                    int firstCircleFoundIndex = years.indexOf(selectedYear);

                    theta = 2240 + firstCircleFoundIndex * 30;

                    int numOfCirclesWithThisYear = 0;
                    for(String y in years){
                      if(y == selectedYear) {
                        numOfCirclesWithThisYear ++;
                      }
                    }

                    searchedCircleIndexes.clear();
                    for (int i = 0; i < numOfCirclesWithThisYear; i++) {
                      searchedCircleIndexes.add(firstCircleFoundIndex + i);
                    }

                    setState(() {
                      placeCircles(coordinatesAndSizes, theta);
                    });

                  },

                );

                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchByYear(),))..then((value) {
                //   setState(() {
                //     placeCircles(coordinatesAndSizes, theta);
                //   });
                //
                // });

                // showModalBottomSheet(
                //     context: context,
                //     builder: (context) {
                //       return SearchByYear();
                //     },
                // );

              },
            ),

            SpeedDialChild(
              child: const Icon(Icons.search),
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              label: 'Search by Name',
              onPressed: () {

                showMaterialResponsiveDialog(
                    backgroundColor: Colors.white,
                    title: 'Search by Name',
                    context: context,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(30.0),
                        child: SearchByName(),
                      ),
                    ),
                    onConfirmed: () {
                      // print(searchingByName);

                      if(names.contains(searchingByName)) {
                        searchedCircleIndexes.clear();
                        searchedCircleIndexes.add(names.indexOf(searchingByName));
                        theta = 2240 + names.indexOf(searchingByName) * 30;
                        setState(() {
                          setState(() {
                            placeCircles(coordinatesAndSizes, theta);
                          });
                        });
                      }

                    },
                );

                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchByName(),))..then((value) {
                //   setState(() {
                //     placeCircles(coordinatesAndSizes, theta);
                //   });
                // });
              },
            ),
            SpeedDialChild(
              child: Checkbox(
                checkColor: Colors.lightBlueAccent,
                value: showLabel,
                onChanged: (bool value) {
                  setState(() {
                    showLabel = value;
                  });
                },
              ),
              foregroundColor: Colors.black,
              backgroundColor: Colors.yellow,
              label: 'Show Temple Labels',
              onPressed: () {
                setState(() {

                });
              },
            ),
            aboutButton(context),
          ],
          closedForegroundColor: Colors.black,
          openForegroundColor: Colors.white,
          closedBackgroundColor: Colors.white,
          openBackgroundColor: Colors.black,
        ),
     // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
