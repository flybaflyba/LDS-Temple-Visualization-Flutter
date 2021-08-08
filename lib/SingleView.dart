
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spiral_vis/Circle.dart';
import 'package:spiral_vis/Universals.dart';
import 'package:spiral_vis/WebViewPage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;



class SingleView extends StatefulWidget{

  SingleView({Key key, this.currentCircleFromWidget}) : super(key: key);

  Circle currentCircleFromWidget;

  @override
  _SingleViewState createState() => _SingleViewState();
}

class _SingleViewState extends State<SingleView> with TickerProviderStateMixin {

  Circle currentCircle;
  Circle lastCircle;
  Circle nextCircle;

  int currentIndex;
  int lastIndex;
  int nextIndex;

  String currentInfo = '';
  // Uint8List currentImageData;
  // bool currentLoadingLargeImageStatus = true;
  bool currentLoadingInfoFileStatus = true;

  // Uint8List lastImageData;
  // bool lastLoadingLargeImageStatus = true;
  // bool lastLoadingInfoFileStatus = true;

  // Uint8List nextImageData;
  // bool nextLoadingLargeImageStatus = true;
  // bool nextLoadingInfoFileStatus = true;

  // int circleIndex = circles.indexOf(widget.currentCircle);
  // print(circleIndex);

  void getCurrentFileData(int index) async {

    // Circle circle = currentCircle;
    Circle circle = circles[index];

    String infoFilePath = 'assets/infos/' + circle.name + '.txt';
    setState(() {
      currentLoadingInfoFileStatus = true;
    });
    currentInfo = await rootBundle.loadString(infoFilePath);
    setState(() {
      currentInfo = currentInfo;
      currentLoadingInfoFileStatus = false;
    });
  }

  void getLargeImage(int index) async {
    // Circle c = circles[index];
    if(circles[index].largeImageData == null) {

      Future.delayed(Duration(milliseconds: 1), () async {
        String imageFilePath;
        setState(() {
          circles[index].largeImageDataLoadingStatus = true;
        });
        if(circles[index].imageAvailability) {
          imageFilePath = 'assets/large_circles/' + circles[index].name + '_large.webp';
        } else {
          imageFilePath = 'assets/large_circles/' + 'no_image' + '_large.webp';
        }
        circles[index].largeImageData = (await rootBundle.load(imageFilePath))
            .buffer
            .asUint8List();
        setState(() {
        circles[index].largeImageData = circles[index].largeImageData;
        circles[index].largeImageDataLoadingStatus = false;
        });
        // print('current large image loaded: ' + circles[index].realName);
      });
    }

  }

  AnimatedPositioned animatedPositionedCircle(Circle c) {

    // Circle c = circles[index];

    var size =
    c.order == 'before last' || c.order == 'after next'
        ?
    min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0
        :
    min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7;

    return AnimatedPositioned(
      duration: Duration(milliseconds: 3000),
      top: 0,
      left:
      c.order == 'last' || c.order == 'before last'
          ?
      MediaQuery.of(context).size.width * 0.5 - min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7 * 1.5
          :
      c.order == 'current'
          ?
      MediaQuery.of(context).size.width * 0.5 - min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7 * 0.5
          :
      c.order == 'next' || c.order == 'after next'
          ?
      MediaQuery.of(context).size.width * 0.5 + min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7 * 0.5
          :
      0,

      child: Center(
        child: Container(
          // color: Colors.red,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Container(
              constraints: BoxConstraints(
                minWidth: size,
                minHeight: size,
                maxWidth: size,
                maxHeight: size,
              ),
              child: Stack(
                children: [
                  c.largeImageDataLoadingStatus
                      ?
                  Container()
                      :
                  c.largeImageData == null
                      ?
                  Container()
                      :
                  Image.memory(c.largeImageData),

                  Center(
                    child: Text(
                      c.imageAvailability ? "" : "No Image",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.1,
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
                  ),

                  IgnorePointer(
                    ignoring: !c.largeImageDataLoadingStatus,
                    child: AnimatedOpacity(
                        opacity: c.largeImageDataLoadingStatus ? 1 : 0,
                        duration: Duration(milliseconds: 1),
                        child: Center(
                            child: Container(
                              // color: Colors.grey[300],
                                child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          shape: BoxShape.circle
                                      ),
                                      // color: Colors.grey[300],
                                      child:
                                      //Center(child: Text(showLoader.toString()),)
                                      SpinKitChasingDots(
                                        color: Colors.blueAccent,
                                        size: 50.0,
                                      ),
                                    )
                                )
                            )
                        )
                    ),
                  )
                ],
              ),

              // widget.circle.image,
              key: ValueKey<int>(currentIndex),
            ),
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();

    currentIndex = circles.indexOf(widget.currentCircleFromWidget);
    lastIndex = currentIndex - 1;
    nextIndex = currentIndex + 1;

    circles[currentIndex].order = 'current';
    circles[lastIndex].order = 'last';
    circles[nextIndex].order = 'next';

    for (Circle c in circles) {
      int i = circles.indexOf(c);
      // if (![currentIndex, lastIndex, nextIndex].contains(i)){
      //   circles[i].order = null;
      // }
      if(i < lastIndex) {
        circles[i].order = 'before last';
      }
      if(i > nextIndex) {
        circles[i].order = 'after next';
      }
    }

    getCurrentFileData(currentIndex);

    getLargeImage(currentIndex);
    getLargeImage(lastIndex);
    getLargeImage(nextIndex);

  }

  Stack largeImages() {

    print(TimeOfDay.now().toString() + ' 1');

    List<AnimatedPositioned> l = [];

    // List<Circle> cs = [];

    for (Circle c in circles) {
      int i = circles.indexOf(c);
      // print(i);
      if(i > currentIndex - 2 || i < currentIndex + 2) {
        l.add(animatedPositionedCircle(c));
      }
    }

    // currentCircle = circles[currentIndex];
    // lastCircle = circles[lastIndex];
    // nextCircle = circles[nextIndex];

    // if(currentCircle == null) {
    //   currentCircle = circles[currentIndex];
    //
    // } else {
    //   // currentCircle.order = circles[currentIndex].order;
    //   // currentCircle.largeImageData = circles[currentIndex].largeImageData;
    //
    // }
    //
    // if(lastCircle == null) {
    //   lastCircle = circles[lastIndex];
    //
    // } else {
    //   // lastCircle.order = circles[lastIndex].order;
    //   // lastCircle.largeImageData = circles[lastIndex].largeImageData;
    // }
    //
    // if(nextCircle == null) {
    //   nextCircle = circles[nextIndex];
    //
    // } else {
    //   // nextCircle.order = circles[nextIndex].order;
    //   // nextCircle.largeImageData = circles[nextIndex].largeImageData;
    // }

    print(TimeOfDay.now().toString() + ' 2');

    return Stack(
      children:

      l,

      // [
      //     animatedPositionedCircle(lastCircle),
      //     animatedPositionedCircle(currentCircle),
      //     animatedPositionedCircle(nextCircle),
      // ],
      // [
      //   animatedPositionedCircle(circles[lastIndex]),
      //   animatedPositionedCircle(circles[currentIndex]),
      //   animatedPositionedCircle(circles[nextIndex]),
      // ],
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(circles[currentIndex].realName),
        actions: [
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Wrap(
            children: [

              Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                      minHeight: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
                      maxWidth: MediaQuery.of(context).size.width,
                      maxHeight: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
                    ),
                    child: largeImages(),
                  )
              ),

              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(10.0),
                    primary: Colors.blue
                    // textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {

                    String url = 'https://www.google.com/search?&tbm=isch&q=' + circles[currentIndex].realName + 'LDS';

                    print(url);
                    if(kIsWeb) {
                      launchInBrowser(url);
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                          WebViewPage(url: url, name: circles[currentIndex].realName,)
                      ));
                    }
                  },
                  child: const Text('See more photos online'),
                ),
              ),

              Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Container(
                        child: Text(
                          'Milestone Dates',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                  ),

                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_left_sharp),
                                color: Colors.blue,
                                iconSize: 80,
                                tooltip: 'Last',
                                onPressed: () {
                                  // int circleIndex = circles.indexOf(currentCircle);
                                  if(currentIndex > 0) {

                                    currentIndex = currentIndex - 1;
                                    lastIndex = currentIndex - 1;
                                    nextIndex = currentIndex + 1;

                                    // if(!currentLoadingInfoFileStatus && !currentLoadingLargeImageStatus) {
                                    if(!currentLoadingInfoFileStatus) {
                                      setState(() {
                                        getLargeImage(currentIndex);
                                        getCurrentFileData(currentIndex);

                                        circles[currentIndex].order = 'current';
                                        circles[lastIndex].order = 'last';
                                        circles[nextIndex].order = 'next';

                                        for (Circle c in circles) {
                                          int i = circles.indexOf(c);
                                          if(i < lastIndex) {
                                            circles[i].order = 'before last';
                                          }
                                          if(i > nextIndex) {
                                            circles[i].order = 'after next';
                                          }
                                        }
                                        getLargeImage(lastIndex);
                                        getLargeImage(nextIndex);
                                      });
                                    } else {
                                      showToast('Loading in progress, please wait', true);
                                    }

                                  } else {
                                    // show no more image
                                    showToast('This is the oldest temple', true);
                                  }

                                },
                              ),

                              Flexible(
                                child:
                                Container(
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 0),
                                    child:
                                    Text(
                                      currentLoadingInfoFileStatus ? 'Loading...' : currentInfo,
                                      textAlign: TextAlign.center,
                                      key: ValueKey<int>(currentIndex),
                                    ),

                                  ),
                                  width: MediaQuery.of(context).size.width * 0.8,
                                ),

                              ),

                              IconButton(
                                icon: const Icon(Icons.arrow_right_sharp),
                                color: Colors.blue,
                                iconSize: 80,
                                tooltip: 'Next',
                                onPressed: () {
                                  if(currentIndex < circles.length - 1) {
                                    if(!currentLoadingInfoFileStatus) {

                                      currentIndex = currentIndex + 1;
                                      lastIndex = currentIndex - 1;
                                      nextIndex = currentIndex + 1;

                                      setState(() {

                                        getLargeImage(currentIndex);
                                        getCurrentFileData(currentIndex);


                                        circles[currentIndex].order = 'current';
                                        circles[lastIndex].order = 'last';
                                        circles[nextIndex].order = 'next';

                                        for (Circle c in circles) {
                                          int i = circles.indexOf(c);
                                          if(i < lastIndex) {
                                            circles[i].order = 'before last';
                                          }
                                          if(i > nextIndex) {
                                            circles[i].order = 'after next';
                                          }
                                        }

                                        getLargeImage(lastIndex);
                                        getLargeImage(nextIndex);

                                      });
                                    } else {
                                      showToast('Loading in Progress, Please Wait', true);
                                    }

                                  } else {
                                    // show no more image
                                    showToast('This is the newest temple', true);
                                  }
                                },
                              ),
                            ],
                          )
                      )
                  ),


                ],
              )

            ],
          ),
        )
      )
    );
  }
}
