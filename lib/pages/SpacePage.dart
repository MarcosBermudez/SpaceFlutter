import 'package:flutter/material.dart';

import 'package:spaceflutter/SpaceFlutterApplication.dart';

class SpacePage extends StatefulWidget {
  final SpacePageState spacePageState = new SpacePageState();

  SpacePage({Key key}) : super(key: key);

  @override
  SpacePageState createState() => spacePageState;
}

class SpacePageState extends State<SpacePage> {
  double tapX, tapY;

  /// List of space objects to draw into application
  List<Positioned> spaceObjectsPositionedForTurn = [];

  /// Number of points of current player
  int points = 0;

  void setSpaceObjects(
      List<Positioned> spaceObjectsPositionedForTurn, int points) {
    setState(() {
      this.spaceObjectsPositionedForTurn = spaceObjectsPositionedForTurn;
      this.points = points;
    });
  }

  void setGameOver(int points) {
    setSpaceObjects(
        spaceObjectsPositionedForTurn = [
          new Positioned(
            top: (SpaceFlutterApplication.height - 60) / 2,
            left: (SpaceFlutterApplication.width - 180) / 2,
            child: new GestureDetector(
              child: new Container(
                child: new Text(
                  "Game Over",
                  style: new TextStyle(fontSize: 20.0),
                ),
                color: Colors.red,
                width: 180.0,
                height: 60.0,
                alignment: FractionalOffset.center,
              ),
              onTapDown: (_) => Navigator.of(context).pushNamed('/'),
            ),
          )
        ],
        points);
  }

  @override
  Widget build(BuildContext context) {

    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new GestureDetector(
      onTapDown: _onTapDown,
      onVerticalDragDown: _onDragDown,
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: (DragEndDetails details) => _navigationEnd(),
      onVerticalDragCancel: () => _navigationEnd(),
      onHorizontalDragDown: _onDragDown,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: (DragEndDetails details) => _navigationEnd(),
      onHorizontalDragCancel: () => _navigationEnd(),
      onTapUp: (_) => _navigationEnd(),
      child: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/space2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: new Stack(
          fit: StackFit.passthrough,
          children: new List.from(spaceObjectsPositionedForTurn)
            ..add(new Positioned(
                top: 30.0,
                left: 20.0,
                child: new Container(
                  color: const Color(0xFF00FF00),
                  width: 120.0,
                  height: 25.0,
                  alignment: FractionalOffset.center,
                  child: new Text(
                    "Points " + points.toString(),
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))),
        ),
      ),
    );
  }

  _onTapDown(TapDownDetails details) {
    tapX = details.globalPosition.dx;
    tapY = details.globalPosition.dy;
  }

  _onDragDown(DragDownDetails details) {
    tapX = details.globalPosition.dx;
    tapY = details.globalPosition.dy;
  }

  _onDragUpdate(DragUpdateDetails details) {
    tapX = details.globalPosition.dx;
    tapY = details.globalPosition.dy;
  }

  _navigationEnd() {
    tapX = null;
    tapY = null;
  }
}
