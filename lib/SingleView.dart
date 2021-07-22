
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

  SingleView({Key key, this.circle}) : super(key: key);

  Circle circle;

  @override
  _SingleViewState createState() => _SingleViewState();
}

class _SingleViewState extends State<SingleView> with TickerProviderStateMixin {

  String info = '';

  Uint8List imageData;

  bool loadingLargeImage = true;
  bool loadingInfoFile = true;

  void getFileData(String path) async {

    setState(() {
      loadingInfoFile = true;
    });

    info = await rootBundle.loadString(path);
    setState(() {
      info = info;
      loadingInfoFile = false;
    });
  }

  void getLargeImage() async {
    String imageFilePath;

    setState(() {
      loadingLargeImage = true;
    });
    if(widget.circle.imageAvailability) {
      imageFilePath = 'assets/large_circles/' + widget.circle.name + '_large.webp';
    } else {
      imageFilePath = 'assets/large_circles/' + 'no_image' + '_large.webp';
    }


    imageData = (await rootBundle.load(imageFilePath))
    .buffer
    .asUint8List();
    setState(() {
      imageData = imageData;
      loadingLargeImage = false;
    });
    print('large image loaded');
  }


  @override
  void initState() {
    super.initState();

    String infoFilePath = 'assets/infos/' + widget.circle.name + '.txt';

    print(infoFilePath);
    getFileData(infoFilePath);

    getLargeImage();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.circle.realName),
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
                              loadingLargeImage
                                  ?
                              Container()
                              :
                              Image.memory(imageData),

                              Center(
                                child: Text(
                                  widget.circle.imageAvailability ? "" : "No Image",
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
                                ignoring: !loadingLargeImage,
                                child: AnimatedOpacity(
                                    opacity: loadingLargeImage ? 1 : 0,
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
                          key: ValueKey<Circle>(widget.circle),
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

                    String url = 'https://www.google.com/search?&tbm=isch&q=' + widget.circle.realName + 'LDS';

                    print(url);
                    if(kIsWeb) {
                      launchInBrowser(url);
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                          WebViewPage(url: url, name: widget.circle.realName,)
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
                                  int circleIndex = circles.indexOf(widget.circle);
                                  if(circleIndex > 0) {

                                    if(!loadingInfoFile && !loadingLargeImage) {
                                      setState(() {
                                        widget.circle = circles[circleIndex - 1];
                                        getLargeImage();
                                        String path = 'assets/infos/' + widget.circle.name + '.txt';
                                        getFileData(path);
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
                                      loadingInfoFile ? 'Loading...' : info,
                                      textAlign: TextAlign.center,
                                      key: ValueKey<Circle>(widget.circle),
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
                                  int circleIndex = circles.indexOf(widget.circle);
                                  if(circleIndex < circles.length - 1) {
                                    if(!loadingInfoFile && !loadingLargeImage) {
                                      setState(() {
                                        widget.circle = circles[circleIndex + 1];
                                        getLargeImage();
                                        String path = 'assets/infos/' + widget.circle.name + '.txt';
                                        getFileData(path);
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
