
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

  String currentInfo = '';
  // Uint8List currentImageData;
  // bool currentLoadingLargeImageStatus = true;
  bool currentLoadingInfoFileStatus = true;

  // Uint8List lastImageData;
  // bool lastLoadingLargeImageStatus = true;
  bool lastLoadingInfoFileStatus = true;

  // Uint8List nextImageData;
  // bool nextLoadingLargeImageStatus = true;
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

  void getLargeImage(Circle c) async {
    String imageFilePath;
    setState(() {
      c.largeImageDataLoadingStatus = true;
    });
    if(c.imageAvailability) {
      imageFilePath = 'assets/large_circles/' + c.name + '_large.webp';
    } else {
      imageFilePath = 'assets/large_circles/' + 'no_image' + '_large.webp';
    }
    c.largeImageData = (await rootBundle.load(imageFilePath))
        .buffer
        .asUint8List();
    setState(() {
      c.largeImageData = c.largeImageData;
      c.largeImageDataLoadingStatus = false;
    });
    print('current large image loaded: ' + c.realName);
  }

  // void getCurrentLargeImage() async {
  //   Circle circle = currentCircle;
  //   String imageFilePath;
  //   setState(() {
  //     currentLoadingLargeImageStatus = true;
  //   });
  //   if(currentCircle.imageAvailability) {
  //     imageFilePath = 'assets/large_circles/' + circle.name + '_large.webp';
  //   } else {
  //     imageFilePath = 'assets/large_circles/' + 'no_image' + '_large.webp';
  //   }
  //   currentImageData = (await rootBundle.load(imageFilePath))
  //   .buffer
  //   .asUint8List();
  //   setState(() {
  //     currentImageData = currentImageData;
  //     currentLoadingLargeImageStatus = false;
  //   });
  //   print('current large image loaded: ' + currentCircle.realName);
  // }
  //
  // void getLastLargeImage() async {
  //   String imageFilePath;
  //   setState(() {
  //     lastLoadingLargeImageStatus = true;
  //   });
  //   if(lastCircle.imageAvailability) {
  //     imageFilePath = 'assets/large_circles/' + lastCircle.name + '_large.webp';
  //   } else {
  //     imageFilePath = 'assets/large_circles/' + 'no_image' + '_large.webp';
  //   }
  //   lastImageData = (await rootBundle.load(imageFilePath))
  //       .buffer
  //       .asUint8List();
  //   setState(() {
  //     lastImageData = lastImageData;
  //     lastLoadingLargeImageStatus = false;
  //   });
  //   print('last large image loaded: ' + lastCircle.realName);
  // }
  //
  // void getNextLargeImage() async {
  //   String imageFilePath;
  //   setState(() {
  //     nextLoadingLargeImageStatus = true;
  //   });
  //   if(nextCircle.imageAvailability) {
  //     imageFilePath = 'assets/large_circles/' + nextCircle.name + '_large.webp';
  //   } else {
  //     imageFilePath = 'assets/large_circles/' + 'no_image' + '_large.webp';
  //   }
  //   nextImageData = (await rootBundle.load(imageFilePath))
  //       .buffer
  //       .asUint8List();
  //   setState(() {
  //     nextImageData = nextImageData;
  //     nextLoadingLargeImageStatus = false;
  //   });
  //   print('next large image loaded: ' + nextCircle.realName);
  // }

  AnimatedPositioned animatedPositionedCircle(Circle c) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      top: 0,
      left:
      c.order == 'last'
          ?
      MediaQuery.of(context).size.width * 0.5 - min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7 * 1.5
          :
      c.order == 'current'
          ?
      MediaQuery.of(context).size.width * 0.5 - min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7 * 0.5
          :
      MediaQuery.of(context).size.width * 0.5 + min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7 * 0.5,
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
                  c.largeImageDataLoadingStatus
                      ?
                  Container()
                      :
                  Image.memory(c.largeImageData),

                  Center(
                    child: Text(
                      lastCircle.imageAvailability ? "" : "No Image",
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
              key: ValueKey<Circle>(currentCircle),
            ),
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();

    currentCircle = widget.currentCircleFromWidget;
    lastCircle = circles[circles.indexOf(currentCircle) - 1];
    nextCircle = circles[circles.indexOf(currentCircle) + 1];

    currentCircle.order = 'current';
    lastCircle.order = 'last';
    nextCircle.order = 'next';

    getCurrentFileData();
    // getCurrentLargeImage();
    //
    // getLastLargeImage();
    // getNextLargeImage();
    getLargeImage(currentCircle);
    getLargeImage(lastCircle);
    getLargeImage(nextCircle);

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
          child: Container(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
            ),
            child: Stack(
              children: [

                // MediaQuery.of(context).size.width * 0.5 - min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7 * 1.5,
                // MediaQuery.of(context).size.width * 0.5 - min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7 * 0.5,
                // MediaQuery.of(context).size.width * 0.5 + min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7 * 0.5,

                // last
                // AnimatedPositioned(
                //   duration: Duration(milliseconds: 500),
                //   top: 0,
                //   left: MediaQuery.of(context).size.width * 0.5 - min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7 * 1.5,
                //   child: Center(
                //     child: Container(
                //       // color: Colors.red,
                //       child: AnimatedSwitcher(
                //         duration: const Duration(milliseconds: 500),
                //         child: Container(
                //           constraints: BoxConstraints(
                //             minWidth: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
                //             minHeight: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
                //             maxWidth: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
                //             maxHeight: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
                //           ),
                //           child: Stack(
                //             children: [
                //               lastLoadingLargeImageStatus
                //                   ?
                //               Container()
                //                   :
                //               Image.memory(lastImageData),
                //
                //               Center(
                //                 child: Text(
                //                   lastCircle.imageAvailability ? "" : "No Image",
                //                   textAlign: TextAlign.center,
                //                   style: TextStyle(
                //                     fontSize: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.1,
                //                     color: Colors.white,
                //                     shadows: <Shadow>[
                //                       Shadow(
                //                         offset: Offset(1.0, 1.0),
                //                         blurRadius: 3.0,
                //                         color: Color.fromARGB(255, 0, 0, 0),
                //                       ),
                //                       Shadow(
                //                         offset: Offset(1.0, 1.0),
                //                         blurRadius: 8.0,
                //                         color: Color.fromARGB(125, 0, 0, 255),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //
                //               IgnorePointer(
                //                 ignoring: !lastLoadingLargeImageStatus,
                //                 child: AnimatedOpacity(
                //                     opacity: lastLoadingLargeImageStatus ? 1 : 0,
                //                     duration: Duration(milliseconds: 1),
                //                     child: Center(
                //                         child: Container(
                //                           // color: Colors.grey[300],
                //                             child: Center(
                //                                 child: Container(
                //                                   decoration: BoxDecoration(
                //                                       color: Colors.grey[300],
                //                                       shape: BoxShape.circle
                //                                   ),
                //                                   // color: Colors.grey[300],
                //                                   child:
                //                                   //Center(child: Text(showLoader.toString()),)
                //                                   SpinKitChasingDots(
                //                                     color: Colors.blueAccent,
                //                                     size: 50.0,
                //                                   ),
                //                                 )
                //                             )
                //                         )
                //                     )
                //                 ),
                //               )
                //             ],
                //           ),
                //
                //           // widget.circle.image,
                //           key: ValueKey<Circle>(currentCircle),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                // current
                // AnimatedPositioned(
                //   duration: Duration(milliseconds: 500),
                //   top: 0,
                //   left: MediaQuery.of(context).size.width * 0.5 - min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7 * 0.5,
                //   child: Center(
                //     child: Container(
                //       // color: Colors.red,
                //       child: AnimatedSwitcher(
                //         duration: const Duration(milliseconds: 500),
                //         child: Container(
                //           constraints: BoxConstraints(
                //             minWidth: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
                //             minHeight: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
                //             maxWidth: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
                //             maxHeight: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
                //           ),
                //           child: Stack(
                //             children: [
                //               currentLoadingLargeImageStatus
                //                   ?
                //               Container()
                //                   :
                //               Image.memory(currentImageData),
                //
                //               Center(
                //                 child: Text(
                //                   currentCircle.imageAvailability ? "" : "No Image",
                //                   textAlign: TextAlign.center,
                //                   style: TextStyle(
                //                     fontSize: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.1,
                //                     color: Colors.white,
                //                     shadows: <Shadow>[
                //                       Shadow(
                //                         offset: Offset(1.0, 1.0),
                //                         blurRadius: 3.0,
                //                         color: Color.fromARGB(255, 0, 0, 0),
                //                       ),
                //                       Shadow(
                //                         offset: Offset(1.0, 1.0),
                //                         blurRadius: 8.0,
                //                         color: Color.fromARGB(125, 0, 0, 255),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //
                //               IgnorePointer(
                //                 ignoring: !currentLoadingLargeImageStatus,
                //                 child: AnimatedOpacity(
                //                     opacity: currentLoadingLargeImageStatus ? 1 : 0,
                //                     duration: Duration(milliseconds: 1),
                //                     child: Center(
                //                         child: Container(
                //                           // color: Colors.grey[300],
                //                             child: Center(
                //                                 child: Container(
                //                                   decoration: BoxDecoration(
                //                                       color: Colors.grey[300],
                //                                       shape: BoxShape.circle
                //                                   ),
                //                                   // color: Colors.grey[300],
                //                                   child:
                //                                   //Center(child: Text(showLoader.toString()),)
                //                                   SpinKitChasingDots(
                //                                     color: Colors.blueAccent,
                //                                     size: 50.0,
                //                                   ),
                //                                 )
                //                             )
                //                         )
                //                     )
                //                 ),
                //               )
                //             ],
                //           ),
                //
                //           // widget.circle.image,
                //           key: ValueKey<Circle>(currentCircle),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                // next
                // AnimatedPositioned(
                //   duration: Duration(milliseconds: 500),
                //   top: 0,
                //   left: MediaQuery.of(context).size.width * 0.5 + min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7 * 0.5,
                //   child: Center(
                //     child: Container(
                //       // color: Colors.red,
                //       child: AnimatedSwitcher(
                //         duration: const Duration(milliseconds: 500),
                //         child: Container(
                //           constraints: BoxConstraints(
                //             minWidth: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
                //             minHeight: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
                //             maxWidth: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
                //             maxHeight: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.7,
                //           ),
                //           child: Stack(
                //             children: [
                //               nextLoadingLargeImageStatus
                //                   ?
                //               Container()
                //                   :
                //               Image.memory(nextImageData),
                //
                //               Center(
                //                 child: Text(
                //                   nextCircle.imageAvailability ? "" : "No Image",
                //                   textAlign: TextAlign.center,
                //                   style: TextStyle(
                //                     fontSize: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.1,
                //                     color: Colors.white,
                //                     shadows: <Shadow>[
                //                       Shadow(
                //                         offset: Offset(1.0, 1.0),
                //                         blurRadius: 3.0,
                //                         color: Color.fromARGB(255, 0, 0, 0),
                //                       ),
                //                       Shadow(
                //                         offset: Offset(1.0, 1.0),
                //                         blurRadius: 8.0,
                //                         color: Color.fromARGB(125, 0, 0, 255),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //
                //               IgnorePointer(
                //                 ignoring: !nextLoadingLargeImageStatus,
                //                 child: AnimatedOpacity(
                //                     opacity: nextLoadingLargeImageStatus ? 1 : 0,
                //                     duration: Duration(milliseconds: 1),
                //                     child: Center(
                //                         child: Container(
                //                           // color: Colors.grey[300],
                //                             child: Center(
                //                                 child: Container(
                //                                   decoration: BoxDecoration(
                //                                       color: Colors.grey[300],
                //                                       shape: BoxShape.circle
                //                                   ),
                //                                   // color: Colors.grey[300],
                //                                   child:
                //                                   //Center(child: Text(showLoader.toString()),)
                //                                   SpinKitChasingDots(
                //                                     color: Colors.blueAccent,
                //                                     size: 50.0,
                //                                   ),
                //                                 )
                //                             )
                //                         )
                //                     )
                //                 ),
                //               )
                //             ],
                //           ),
                //
                //           // widget.circle.image,
                //           key: ValueKey<Circle>(currentCircle),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                animatedPositionedCircle(lastCircle),
                animatedPositionedCircle(currentCircle),
                animatedPositionedCircle(nextCircle),

              ],
            ),
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

                                    // if(!currentLoadingInfoFileStatus && !currentLoadingLargeImageStatus) {
                                    if(!currentLoadingInfoFileStatus) {
                                      setState(() {
                                        currentCircle = circles[circleIndex - 1];
                                        // getCurrentLargeImage();
                                        getLargeImage(currentCircle);
                                        // String path = 'assets/infos/' + widget.circle.name + '.txt';
                                        getCurrentFileData();

                                        lastCircle = circles[circles.indexOf(currentCircle) - 1];
                                        nextCircle = circles[circles.indexOf(currentCircle) + 1];

                                        // getLastLargeImage();
                                        // getNextLargeImage();
                                        getLargeImage(lastCircle);
                                        getLargeImage(nextCircle);
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
                                    // if(!currentLoadingInfoFileStatus && !currentLoadingLargeImageStatus) {
                                    if(!currentLoadingInfoFileStatus) {
                                      setState(() {

                                        // nextCircle = currentCircle; // circles[circles.indexOf(currentCircle) + 1];
                                        // currentCircle = lastCircle; // circles[circleIndex + 1];
                                        // lastCircle = circles[circles.indexOf(currentCircle) - 1];

                                        nextCircle.order = 'current';
                                        currentCircle.order = 'next';
                                        lastCircle.order = 'last';

                                        // getCurrentLargeImage();
                                        getLargeImage(currentCircle);
                                        // String path = 'assets/infos/' + widget.circle.name + '.txt';
                                        getCurrentFileData();


                                        // getLastLargeImage();
                                        // getNextLargeImage();
                                        getLargeImage(lastCircle);
                                        getLargeImage(nextCircle);
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
