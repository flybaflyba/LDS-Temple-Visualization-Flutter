
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_material_pickers/helpers/show_responsive_dialog.dart';
import 'package:flutter_material_pickers/helpers/show_scroll_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:share_plus/share_plus.dart';
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

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:spiral_vis/WebViewPage.dart';


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

  // var sampleW = 100.0;



  Future<void> prepareCircles() async {
    // circles.clear();

    // for(Circle c in circles) {
    //   c.imageData = null;
    // }

    for (Circle c in circles) {
      setState(() {
        c.imageData = null;
      });
    }

    loaded = 0.0;
    setState(() {
      loadingAssets = true;
    });
    const duration = const Duration(milliseconds: 100);
    timer = new Timer.periodic(duration, (Timer t) {
      // print('loading ' + DateTime.now().toString());
      if(!loadingAssets) {
        timer.cancel();
      }
      // print('update screen');
      setState(() {
        loaded = loaded; // (loaded - 0.0000000000001).abs();
      });
      // print(loaded);

    });


    if(circles.isEmpty) {
      await loadCircles(context);

    }
    setState(() {
      placeCircles(coordinatesAndSizes, theta);
    });

    await loadImages(context);

    print('finish loading assets');
    setState(() {
      loadingAssets = false;
      placeCircles(coordinatesAndSizes, theta);
    });
  }

  bool showYearsRange = true;

  Timer timer;

  @override
  void initState() {
    super.initState();

    getCoordinatesAndSizes();

    // setState(() {
    //
    // });

    prepareCircles().then((value) {

    });

    print("circles.length is: " + circles.length.toString());

  }

  void spin(int speed){
    setState(() {
      if ((theta + speed * 0.5).toInt() >= 2240 && (theta + speed * 0.5).toInt() <= 9820) {
        theta = (theta + speed * 0.5).toInt();
        placeCircles(coordinatesAndSizes, theta);
      } else {
        showToast((speed > 0 ? 'Ending': 'Beginning') + ' of spiral', true);
      }
    });
  }


  Stack buildLayout(BoxConstraints constraints) {

    // print('building circle');

    double magicNumber = min(constraints.maxWidth, constraints.maxHeight);

    double magicNumberAnother = magicNumber;

    bool portrait = true;

    if (MediaQuery.of(context).orientation == Orientation.portrait){
      // is portrait
      // print('portrait');
      portrait = true;
      // if(constraints.maxHeight <= constraints.maxWidth * 0.6) {
      //   magicNumber = min(constraints.maxWidth, constraints.maxHeight);
      // } else {
      //   magicNumber = min(constraints.maxWidth, constraints.maxHeight) * 0.8;
      // }
    }else{
      // is landscape
      // print('landscape');
      portrait = false;
      magicNumberAnother = max(constraints.maxWidth, constraints.maxHeight);

      magicNumber = min(constraints.maxWidth, constraints.maxHeight) * 0.9;

      // if(constraints.maxWidth <= constraints.maxHeight * 0.6) {
      //   magicNumber = min(constraints.maxWidth, constraints.maxHeight);
      // } else {
      //   magicNumber = min(constraints.maxWidth, constraints.maxHeight) * 0.8;
      // }
    }

    // print(constraints.maxWidth);
    // print(constraints.maxHeight);

    List<AnimatedPositioned> elements = [];

    double specialSizeRatio = 1.33;

    for(int i = 0; i < circles.length; i++){
      double x = circles[i].x == null ? 0 : circles[i].x;
      double y = circles[i].y == null ? 0 : circles[i].y;
      double size = circles[i].size  == null ? 0 : circles[i].size;
      // Image image = circles[i].image  == null ? 0 : circles[i].image;
      Uint8List imageData = circles[i].imageData  == null ? null : circles[i].imageData;
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
                      width: size * magicNumber * specialSizeRatio,
                      height: size * magicNumber * specialSizeRatio,
                    // color: Colors.blue,
                    child:

                    imageData == null ?

                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle
                      ),
                      // color: Colors.grey[300],
                      child:
                      //Center(child: Text(showLoader.toString()),)
                      SpinKitChasingDots(
                        color: Colors.blueAccent,
                        size: size * magicNumber * specialSizeRatio * 0.4,
                      ),
                    )
                        :
                    Image.memory(
                      imageData,
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.none,
                      frameBuilder: (BuildContext context, Widget child, int frame,
                          bool wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        }
                        return AnimatedOpacity(
                          child: child,
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(seconds: 2),
                          curve: Curves.easeOut,
                        );
                      },
                    ),

                    // image,
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
                                  // fontSize: magicNumber * specialSizeRatio * 0.01,
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
                                } else {
                                  showToast('Beginning of spiral', true);
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
                                });

                                if(value == 2240) {
                                  showToast('Beginning of spiral', true);
                                } else if(value == 9820) {
                                  showToast('End of spiral', true);
                                }
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
                                  } else {
                                    showToast('End of spiral', true);
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

          IconButton(
              icon: const Icon(Icons.list),
              color: Colors.white,
              tooltip: 'Temples List',
              onPressed: () {
                if(loadingAssets) {
                  showToast('Please wait for loading to finish', true);
                } else {
                  String url = 'https://www.churchofjesuschrist.org/temples/list?lang=eng';
                  if(kIsWeb) {
                    launchInBrowser(url);
                  } else {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>
                            WebViewPage(url: url, name: 'Temples List',)
                        ));
                  }
                }

              }
          ),
          IconButton(
              icon: const Icon(Icons.refresh),
              color: Colors.white,
              tooltip: 'Refresh',
              onPressed: () {
                if(loadingAssets) {
                  showToast('Please wait for loading to finish', true);
                } else {
                  showToast('Refreshing Page', false);
                  prepareCircles();
                  theta = 7000;
                  placeCircles(coordinatesAndSizes, theta);
                }
                // launchInBrowser('https://latterdaytemples.litianzhang.com/');
              }
          ),

          kIsWeb
              ?
          IconButton(
              icon: const Icon(Icons.link),
              color: Colors.white,
              tooltip: 'App Website',
              onPressed: () {
                if(loadingAssets) {
                  showToast('Please wait for loading to finish', true);
                } else {
                  launchInBrowser('https://latterdaytemples.litianzhang.com/related-links-english/');
                }
              }
          )
              :
          IconButton(
              icon: const Icon(Icons.ios_share),
              color: Colors.white,
              tooltip: 'Share',
              onPressed: () {
                Share.share('Temples Timeline App \nSpiral Visualization for the temples of The Church of Jesus Christ of Latter-day Saints by students and professors at Brigham Young University Hawaii.\n Visit at https://latterdaytemples.litianzhang.com/');
              }
          ),
    ],
      ),
      body:

          Stack(
            children: [

              LayoutBuilder (
                builder: (context, constraints) {
                  return buildLayout(constraints);
                },
              ),




              // Container(
              //   color: loadingAssets ? Colors.white : Color.fromRGBO(0, 0, 0, 0),
              // ),

              // IgnorePointer(
              //   ignoring: !loadingAssets,
              //   child: AnimatedOpacity(
              //       opacity: loadingAssets ? 1 : 1,
              //       duration: Duration(milliseconds: 500),
              //       child: Center(
              //           child: Container(
              //           )
              //       )
              //   ),
              // ),

              Column(
                children: [
                  IgnorePointer(
                    ignoring: !loadingAssets,
                    child: AnimatedOpacity(
                        opacity: loadingAssets ? 1 : 0,
                        duration: Duration(milliseconds: 500),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                            child: Center(
                              child: Container(
                                constraints: BoxConstraints(
                                  minWidth: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.9,
                                  minHeight: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.1,
                                  maxWidth: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.9,
                                  maxHeight: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.1,
                                ),
                                // color: Colors.grey[300],
                                child:
                                //Center(child: Text(showLoader.toString()),)
                                // SpinKitChasingDots(
                                //   color: Colors.blueAccent,
                                //   size: 50.0,
                                // ),
                                // Padding(
                                //   padding: EdgeInsets.all(15.0),
                                //   child: new LinearPercentIndicator(
                                //     // width: MediaQuery.of(context).size.width - 50,
                                //     animation: true,
                                //     lineHeight: 30.0,
                                //     // animationDuration: 2000,
                                //     percent: loaded,
                                //     center: Text(
                                //       "Loading No. " + (loaded * totalCircles).toInt().toString() + ' of ' + totalCircles.toString() + ' images... ' + (loaded * 100).floorToDouble().toString() + '%',
                                //       textAlign: TextAlign.center,
                                //       style: TextStyle(
                                //         fontSize: 15,
                                //         color: Colors.black,
                                //       ),
                                //     ),
                                //     linearStrokeCap: LinearStrokeCap.roundAll,
                                //     progressColor: Colors.greenAccent,
                                //   ),
                                // ),

                                LiquidLinearProgressIndicator(
                                    value: loaded, // 0.65, // Defaults to 0.5.
                                    valueColor: AlwaysStoppedAnimation(Colors.lightBlueAccent), // Defaults to the current Theme's accentColor.
                                    backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                                    borderColor: Colors.blue,
                                    borderWidth: 5.0,
                                    borderRadius: 100,
                                    direction: Axis.horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                                    center: Wrap(
                                      children: [
                                        Text(
                                          "Loading No. " + (loaded * totalCircles).toInt().toString() + ' of ' + totalCircles.toString() + ' images... ' + (loaded * 100).floorToDouble().toString() + '%',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            )
                        )
                    ),
                  ),
                ],
              )



            ],
          ),



        floatingActionButton: SpeedDial(
          child: const Icon(Icons.add),
          speedDialChildren: <SpeedDialChild>[
            SpeedDialChild(
              child: const Icon(Icons.calendar_today),
              foregroundColor: Colors.blueGrey,
              backgroundColor: Colors.greenAccent,
              label: 'Pick a Year',
              onPressed: () {

                print(distinctYears);

                if(loadingAssets) {
                showToast('Please wait for loading to finish', true);
                } else {
                  showMaterialScrollPicker<String>(
                    backgroundColor: Colors.white,
                    context: context,
                    title: 'Pick a Year',
                    items: distinctYears,
                    selectedItem: selectedYear,
                    showDivider: false,
                    onChanged: (value) => setState(() => selectedYear = value),
                    onCancelled: () {
                      showToast('Pick a Year cancelled', false);

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

                      if(selectedYear.length == 4) {
                        showToast('Showing year ' + selectedYear.toLowerCase() + ' temples', false);
                      } else if(selectedYear == 'Under Construction') {
                        showToast('Showing ' + selectedYear.toLowerCase() + ' temples', false);
                      } else {
                        showToast('Showing ' + selectedYear.toLowerCase(), false);
                      }

                    },

                  );
                }



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
                if(loadingAssets) {
                  showToast('Please wait for loading to finish', true);
                } else {
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
                    onCancelled: () {
                      showToast('Search by Name cancelled', false);
                    },
                    onConfirmed: () {
                      // print(searchingByName);

                      if(names.contains(searchingByName)) {
                        searchedCircleIndexes.clear();
                        searchedCircleIndexes.add(names.indexOf(searchingByName));
                        theta = 2240 + names.indexOf(searchingByName) * 30;
                        setState(() {
                          placeCircles(coordinatesAndSizes, theta);
                        });
                        showToast('Showing $searchingByName', false);
                      } else {
                        showToast('No temple found', true);
                      }

                    },
                  );
                }
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

                  if(loadingAssets) {
                    showToast('Please wait for loading to finish', true);
                  } else {
                    setState(() {
                      showLabel = value;
                    });
                    if(value) {
                      showToast('Showing temple labels', false);
                    } else{
                      showToast('Hide temple labels', false);
                    }
                  }
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

            SpeedDialChild(
              child: const Icon(Icons.house_rounded),
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              label: 'Temple Open Houses and Dedications',
              onPressed: () {
                if(loadingAssets) {
                  showToast('Please wait for loading to finish', true);
                } else {
                  String url = 'https://www.churchofjesuschrist.org/temples/open-houses?lang=eng';
                  if(kIsWeb) {
                    launchInBrowser(url);
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                        WebViewPage(url: url, name: 'Open Houses and Dedications',)
                    ));
                  }
                }
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
