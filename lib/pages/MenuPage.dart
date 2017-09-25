import 'package:flutter/material.dart';

import 'package:spaceflutter/SpaceFlutterApplication.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (SpaceFlutterApplication.width == null) {
      SpaceFlutterApplication.height = MediaQuery.of(context).size.height;
      SpaceFlutterApplication.width = MediaQuery.of(context).size.width;
      print("Size is " +
          SpaceFlutterApplication.height.toString() +
          "," +
          SpaceFlutterApplication.width.toString());
    }

    return new Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("assets/images/space1.png"),
          fit: BoxFit.cover,
        ),
      ),
      alignment: FractionalOffset.center,
      child: new GestureDetector(
        child: new Container(
          color: const Color(0xFF00FF00),
          width: 180.0,
          height: 60.0,
          alignment: FractionalOffset.center,
          child: new Text(
            'Start Game',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),
          ),
        ),
        onTapUp: ((_) => Navigator.of(context).pushNamed('space')),
      ),
    );
  }
}