
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

  String currentInfo = '';
  Uint8List currentImageData;
  bool currentLoadingLargeImageStatus = true;
  bool currentLoadingInfoFileStatus = true;

  Uint8List lastImageData;
  bool lastLoadingLargeImageStatus = true;
  bool lastLoadingInfoFileStatus = true;

  Uint8List nextImageData;
  bool nextLoadingLargeImageStatus = true;
  bool nextLoadingInfoFileStatus = true;

  // int circleIndex = circles.indexOf(widget.currentCircle);
  // print(circleIndex);

  void getCurrentFileData() async {
    Circle circle = currentCircle;
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

  void getCurrentLargeImage() async {
    Circle circle = currentCircle;
    String imageFilePath;
    setState(() {
      currentLoadingLargeImageStatus = true;
    });
    if(currentCircle.imageAvailability) {
      imageFilePath = 'assets/large_circles/' + circle.name + '_large.webp';
    } else {
      imageFilePath = 'assets/large_circles/' + 'no_image' + '_large.webp';
    }
    currentImageData = (await rootBundle.load(imageFilePath))
    .buffer
    .asUint8List();
    setState(() {
      currentImageData = currentImageData;
      currentLoadingLargeImageStatus = false;
    });
    print('currentlarge image loaded');
  }

  void getLastLargeImage() async {
    Circle circle = circles[circles.indexOf(currentCircle) - 1];
    String imageFilePath;
    setState(() {
      lastLoadingLargeImageStatus = true;
    });
    if(circle.imageAvailability) {
      imageFilePath = 'assets/large_circles/' + circle.name + '_large.webp';
    } else {
      imageFilePath = 'assets/large_circles/' + 'no_image' + '_large.webp';
    }
    lastImageData = (await rootBundle.load(imageFilePath))
        .buffer
        .asUint8List();
    setState(() {
      lastImageData = lastImageData;
      lastLoadingLargeImageStatus = false;
    });
    print('last large image loaded');
  }

  void getNextLargeImage() async {
    Circle circle = circles[circles.indexOf(currentCircle) + 1];
    String imageFilePath;
    setState(() {
      nextLoadingLargeImageStatus = true;
    });
    if(circle.imageAvailability) {
      imageFilePath = 'assets/large_circles/' + circle.name + '_large.webp';
    } else {
      imageFilePath = 'assets/large_circles/' + 'no_image' + '_large.webp';
    }
    nextImageData = (await rootBundle.load(imageFilePath))
        .buffer
        .asUint8List();
    setState(() {
      nextImageData = nextImageData;
      nextLoadingLargeImageStatus = false;
    });
    print('next large image loaded');
  }


  @override
  void initState() {
    super.initState();

    currentCircle = widget.currentCircleFromWidget;

    getCurrentFileData();
    getCurrentLargeImage();

    getLastLargeImage();
    getNextLargeImage();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(currentCircle.realName),
        actions: [
          //
          // IconButton(
          //     icon: const Icon(Icons.photo_album),
          //     color: Colors.white,
          //     tooltip: 'More Photos',
          //     onPressed: () {
          //       String url = 'https://www.churchofjesuschrist.org/temples/photo-gallery?lang=eng';
          //       if(kIsWeb) {
          //         launchInBrowser(url);
          //       } else {
          //         Navigator.of(context).push(
          //             MaterialPageRoute(builder: (context) =>
          //                 WebViewPage(url: url, name: 'Official Photos',)
          //             ));
          //       }
          //     }
          // )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Wrap(
            children: [

          Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Container(
              // color: Colors.red,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
                    minHeight: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
                    maxWidth: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
                    maxHeight: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
                  ),
                  child: Stack(
                    children: [
                      currentLoadingLargeImageStatus
                          ?
                      Container()
                          :
                      Image.memory(currentImageData),

                      Center(
                        child: Text(
                          currentCircle.imageAvailability ? "" : "No Image",
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
                        ignoring: !currentLoadingLargeImageStatus,
                        child: AnimatedOpacity(
                            opacity: currentLoadingLargeImageStatus ? 1 : 0,
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
                  key: ValueKey<Circle>(currentCircle),
                ),
              ),
            ),
          ),
        ),

              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(10.0),
                    primary: Colors.blue
                    // textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {

                    String url = 'https://www.google.com/search?&tbm=isch&q=' + currentCircle.realName + 'LDS';

                    print(url);
                    if(kIsWeb) {
                      launchInBrowser(url);
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                          WebViewPage(url: url, name: currentCircle.realName,)
                      ));
                    }

                    //   String urlEndding = widget.circle.realName.toLowerCase().replaceAll(' ', '-').substring(0, widget.circle.realName.length - 1) + '?lang=eng';
                    //   String url = 'https://www.churchofjesuschrist.org/temples/photo-gallery/' + urlEndding;
                    //
                    //   print(url);
                    //   if(kIsWeb) {
                    //     launchInBrowser(url);
                    //   } else {
                    //     Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                    //         WebViewPage(url: url, name: widget.circle.realName,)
                    //     ));
                    //   }

                    // if(widget.circle.imageAvailability == false) {
                    //   // showToast('No Photos for ' + widget.circle.realName + '. Showing Other Temples\' Photos', false);
                    //   String url = 'https://www.churchofjesuschrist.org/temples/photo-gallery?lang=eng';
                    //   if(kIsWeb) {
                    //     launchInBrowser(url);
                    //   } else {
                    //     Navigator.of(context).push(
                    //         MaterialPageRoute(builder: (context) =>
                    //             WebViewPage(url: url, name: 'Photos',)
                    //         ));
                    //   }
                    // } else {
                    //   String urlEndding = widget.circle.realName.toLowerCase().replaceAll(' ', '-').substring(0, widget.circle.realName.length - 1) + '?lang=eng';
                    //   String url = 'https://www.churchofjesuschrist.org/temples/photo-gallery/' + urlEndding;
                    //
                    //   print(url);
                    //   if(kIsWeb) {
                    //     launchInBrowser(url);
                    //   } else {
                    //     Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                    //         WebViewPage(url: url, name: widget.circle.realName,)
                    //     ));
                    //   }
                    // }
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
                                  int circleIndex = circles.indexOf(currentCircle);
                                  if(circleIndex > 0) {

                                    if(!currentLoadingInfoFileStatus && !currentLoadingLargeImageStatus) {
                                      setState(() {
                                        currentCircle = circles[circleIndex - 1];
                                        getCurrentLargeImage();
                                        // String path = 'assets/infos/' + widget.circle.name + '.txt';
                                        getCurrentFileData();

                                        getLastLargeImage();
                                        getNextLargeImage();
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
                                      key: ValueKey<Circle>(currentCircle),
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
                                  int circleIndex = circles.indexOf(currentCircle);
                                  if(circleIndex < circles.length - 1) {
                                    if(!currentLoadingInfoFileStatus && !currentLoadingLargeImageStatus) {
                                      setState(() {
                                        currentCircle = circles[circleIndex + 1];
                                        getCurrentLargeImage();
                                        // String path = 'assets/infos/' + widget.circle.name + '.txt';
                                        getCurrentFileData();

                                        getLastLargeImage();
                                        getNextLargeImage();
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

                  // Padding(
                  //     padding: EdgeInsets.only(top: 10, bottom: 20),
                  //     child: Container(
                  //       child: TextButton(
                  //         style: TextButton.styleFrom(
                  //           padding: const EdgeInsets.all(16.0),
                  //           primary: Colors.blue,
                  //           textStyle: const TextStyle(fontSize: 20),
                  //         ),
                  //         onPressed: () {
                  //
                  //         },
                  //         child: const Text('View Official Website'),
                  //       ),
                  //     )
                  // ),

                ],
              )

            ],
          ),
        )
      )
    );
  }
}
