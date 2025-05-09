import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spiral_vis/About.dart';

import 'Universals.dart';

class Settings extends StatefulWidget{

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('More'),
        ),
      body: Center(
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 400,
                  ),
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      goToWebPage(context, 'https://latterdaytemples.litianzhang.com/related-links-english/', 'App Page');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.link,
                          color: Colors.white,
                        ),
                        Text(
                          'App Website',
                          style: TextStyle(
                            // fontSize: 20,
                            color: Colors.white,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),

              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 400,
                  ),
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      String url = 'https://www.churchofjesuschrist.org/temples/list?lang=eng';
                      goToWebPage(context, url, 'Temple List');

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.list,
                          color: Colors.white,
                        ),
                        Text(
                          'Temple List',
                          style: TextStyle(
                            // fontSize: 20,
                            color: Colors.white,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),

              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 400,
                  ),
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      String url = 'https://www.churchofjesuschrist.org/temples/open-houses?lang=eng';
                      goToWebPage(context, url, 'Temple Open Houses and Dedications');

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.house,
                          color: Colors.white,
                        ),
                        Text(
                          'Temple Open Houses And Dedications',
                          style: TextStyle(
                            // fontSize: 20,
                            color: Colors.white,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),

              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 400,
                  ),
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      String url = 'https://www.churchofjesuschrist.org/temples/photo-gallery?lang=eng';
                      goToWebPage(context, url, 'Official Gallery');

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.photo,
                          color: Colors.white,
                        ),
                        Text(
                          'Official Gallery',
                          style: TextStyle(
                            // fontSize: 20,
                            color: Colors.white,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),

              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 400,
                  ),
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      String url = 'https://latterdaytemples.litianzhang.com/feedback-english/';
                      goToWebPage(context, url, 'Feedback');

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        Text(
                          'Feedback',
                          style: TextStyle(
                            // fontSize: 20,
                            color: Colors.white,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),

              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 400,
                  ),
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      aboutShow(context);

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.developer_mode,
                          color: Colors.white,
                        ),
                        Text(
                          'About the App',
                          style: TextStyle(
                            // fontSize: 20,
                            color: Colors.white,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),

              kIsWeb
                  ?
              Container()
                  :
              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 400,
                  ),
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      Share.share('Temples Timeline App \nSpiral Visualization for the temples of The Church of Jesus Christ of Latter-day Saints by students and professors at Brigham Young University Hawaii.\n Visit at https://latterdaytemples.litianzhang.com/');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.ios_share,
                          color: Colors.white,
                        ),
                        Text(
                          'Share',
                          style: TextStyle(
                            // fontSize: 20,
                            color: Colors.white,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

/**
 * TODO 1. add different effect. 2. redesign layout

 **/