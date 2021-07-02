
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spiral_vis/Circle.dart';

class SingleView extends StatefulWidget{

  SingleView({Key key, this.circle}) : super(key: key);

  final Circle circle;

  @override
  _SingleViewState createState() => _SingleViewState();
}

class _SingleViewState extends State<SingleView>{

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.circle.realName),
        actions: [
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(child: widget.circle.image,),
          ),

        ],
      )
    );
  }
}
