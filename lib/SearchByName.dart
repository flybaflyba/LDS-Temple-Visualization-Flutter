import 'package:flutter/material.dart';
import 'package:spiral_vis/Caculation.dart';
import 'package:spiral_vis/Universals.dart';

class SearchByName extends StatefulWidget{

  @override
  _SearchByNameState createState() => _SearchByNameState();
}

class _SearchByNameState extends State<SearchByName>{

  var typedName = "";
  TextEditingController typedNameTextEditingController = new TextEditingController();
  List<dynamic> filteredNames = [];
  List<Widget> list = [];

  Column listMatchedCourses(String enteredString) {

    print(enteredString);

    if(enteredString == '') {
      enteredString = ' ';
    }

    setState(() {
      filteredNames = names
          .where((name) =>
              name.toLowerCase().contains(enteredString.toLowerCase()))
          .toList();
      if(filteredNames.length == 0 && !names.contains(enteredString)) {
        filteredNames.add("No Temple Found");
      }

    });

    list = [];
    if (enteredString != "") {
      for(var i = filteredNames.length - 1; i > -1; i--){
        String temp = filteredNames[i];
        list.add(
          Container(
            margin: EdgeInsets.all(5),
            child: Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                ),
                onPressed: () {
                  if (temp != "No Temple Found") {
                    setState(() {
                      typedName = temp;
                      typedNameTextEditingController.text = temp;
                      searchingByName = typedName;
                    });
                  }
                },
                child: Text(
                  temp,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      }
    }

    return new Column(
      children: list,
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Container(
                    color: Colors.white,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: typedNameTextEditingController,
                      onChanged: (value){
                        setState(() {
                          typedName = value;
                          searchingByName = typedName;
                        });
                        // print(course);
                      },
                      decoration: InputDecoration(
                        hintText: "type a temple name",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                ),

                // Padding(
                //   padding: const EdgeInsets.only(bottom: 5),
                //   child: ElevatedButton(
                //     child: Text((names.contains(typedName) ? 'Show $typedName' : 'Cancel')),
                //     onPressed: () {
                //       if(names.contains(typedName)) {
                //         // update
                //         print(names.indexOf(typedName));
                //
                //         // searchedCircleIndexes.clear();
                //         // searchedCircleIndexes.add(names.indexOf(typedName));
                //         // theta = 2240 + names.indexOf(typedName) * 30;
                //
                //         Navigator.pop(context);
                //
                //       } else {
                //         Navigator.pop(context);
                //       }
                //     },
                //   ),
                // ),

                listMatchedCourses(typedName),

              ],
            ),
          ],
        )
      )


    );
  }
}