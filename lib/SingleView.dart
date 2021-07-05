
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void getFileData(String path) async {
    info = await rootBundle.loadString(path);
    setState(() {
      info = info;
    });
  }

  @override
  void initState() {
    super.initState();

    String path = 'assets/infos/' + widget.circle.name + '.txt';

    getFileData(path);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.circle.realName),
        actions: [
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
                          child: widget.circle.image,
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

                    String urlEndding =  widget.circle.realName.toLowerCase().replaceAll(' ', '-').substring(0, widget.circle.realName.length - 1);
                    String url = 'https://www.churchofjesuschrist.org/temples/photo-gallery/' + urlEndding;

                    print(url);

                    if(kIsWeb) {
                      launchInBrowser(url);
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                          WebViewPage(url: url, name: widget.circle.realName,)
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
                          'Mile Stone Dates',
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
                                    setState(() {
                                      widget.circle = circles[circleIndex - 1];
                                      String path = 'assets/infos/' + widget.circle.name + '.txt';
                                      getFileData(path);
                                    });
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
                                      info,
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
                                    setState(() {
                                      widget.circle = circles[circleIndex + 1];
                                      String path = 'assets/infos/' + widget.circle.name + '.txt';
                                      getFileData(path);
                                    });
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
