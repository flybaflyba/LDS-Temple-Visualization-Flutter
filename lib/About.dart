import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/helpers/show_responsive_dialog.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:spiral_vis/Universals.dart';


void aboutShow(BuildContext context) {

  showMaterialResponsiveDialog(
      backgroundColor: Colors.white,
      title: 'About Temples Timeline',
      context: context,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Programming by Tsz Chin Lam, Abigail Smith, and Litian Zhang under the supervision of Dr. Geoffrey Draper at Brigham Young University--Hawaii.'),
                Text(''),
                Text('Temple photos are copyrighted by Intellectual Reserve, Inc. Used by permission.'),
                Text(''),
                Text('This app is a research project funded by Brigham Young University--Hawaii, however the contents are the responsibility of its developers. This app is not an \"official\" publication of the Church of Jesus Christ of Latter-day Saints.'),
                Text(''),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    goToWebPage(context, 'https://latterdaytemples.litianzhang.com/related-links-english/', 'App Page');
                    },
                  child: Text('Visit App website'),
                ),
              ],
            ),
          ),
        ),
      ),
      onConfirmed: () {
      },
      cancelText: ''
  );
}