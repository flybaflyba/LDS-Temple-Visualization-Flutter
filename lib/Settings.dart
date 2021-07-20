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
      body: ListView(
        children: [

          Center(
            child: Container(
              constraints: BoxConstraints(
                 maxWidth: 400,
              ),
              padding: EdgeInsets.all(10),
              child: RaisedButton(
                onPressed: () {
                  goToWebPage(context, 'https://latterdaytemples.litianzhang.com/related-links-english/', 'App Page');
                },
                color: Theme.of(context).accentColor,
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
              child: RaisedButton(
                onPressed: () {
                  String url = 'https://www.churchofjesuschrist.org/temples/list?lang=eng';
                  goToWebPage(context, url, 'Temple List');

                  },
                color: Theme.of(context).accentColor,
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
              child: RaisedButton(
                onPressed: () {
                  String url = 'https://www.churchofjesuschrist.org/temples/open-houses?lang=eng';
                  goToWebPage(context, url, 'Temple Open Houses and Dedications');

                },
                color: Theme.of(context).accentColor,
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
              child: RaisedButton(
                onPressed: () {
                  String url = 'https://www.churchofjesuschrist.org/temples/photo-gallery?lang=eng';
                  goToWebPage(context, url, 'Official Gallery');

                },
                color: Theme.of(context).accentColor,
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
              child: RaisedButton(
                onPressed: () {
                  Share.share('Temples Timeline App \nSpiral Visualization for the temples of The Church of Jesus Christ of Latter-day Saints by students and professors at Brigham Young University Hawaii.\n Visit at https://latterdaytemples.litianzhang.com/');
                },
                color: Theme.of(context).accentColor,
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
      )
    );
  }
}

/**
 * TODO 1. add different effect. 2. redesign layout

 **/