
import 'package:flutter/material.dart';

class SingleView extends StatefulWidget{

  @override
  _SingleViewState createState() => _SingleViewState();
}

class _SingleViewState extends State<SingleView>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Blank Page"),),
    );
  }
}
