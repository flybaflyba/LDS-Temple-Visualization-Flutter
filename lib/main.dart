import 'package:flutter/material.dart';
import 'package:spiral_vis/MyHomePage.dart';
import 'package:spiral_vis/SingleView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temples Timeline',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: '/MyHomePage',
      routes: {
        '/MyHomePage' : (context) => MyHomePage(title: 'Temples Timeline',),
        '/SingleView' : (context) => SingleView(),

      },

    );
  }
}
