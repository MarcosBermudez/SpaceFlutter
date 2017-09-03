import 'dart:async';

import 'package:flutter/material.dart';
import 'package:duende/SapceObjects.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new SpacePage();
  }
}

class SpacePage extends StatefulWidget {
  SpacePage({Key key}) : super(key: key);

  @override
  _SpacePageState createState() => new _SpacePageState();
}

class _SpacePageState extends State<SpacePage> {
  final Duration turnDuration = new Duration(milliseconds: 5);

  final Spaceship ship = new Spaceship(Colors.green);
  final Missile missile = new Missile();

  var tapX = null;
  var tapY = null;
  Timer t;

  List<HasTurn> spaceObjects = null;
  List<Positioned> spaceObjectsPositionedForTurn = [];

  @override
  void initState() {
    super.initState();
    t = new Timer.periodic(turnDuration, (Timer tim) => turn());

    //Initialize start
    spaceObjects = [ship, missile];
  }

  void turn() {

    List<HasTurn> ships = spaceObjects.where((o)=>!o.isMissile()).toList();
    List<HasTurn> missiles = spaceObjects.where((o)=>o.isMissile()).toList();

    double r = 50.0;

    // TODO Calculate missile impacts
    missiles.forEach((HasTurn m)=>
      ships.where((s)=>isImpact(m, s)).forEach((s) =>s.impacted(m)));


    // Calculate new position for each of the space objects
    setState(() => spaceObjectsPositionedForTurn =
      spaceObjects.map((t) => t.performTurn(tapX, tapY)).toList());

    // TODO Calculate new space objects

  }

  bool isImpact(HasTurn missile, HasTurn spaceObject){

    // TODO
    double mx =missile.lastLeft;
    double my =missile.lastTop;
    double mw =missile.width;
    double mh =missile.height;

    double sx =spaceObject.lastLeft;
    double sy =spaceObject.lastTop;
    double sw =spaceObject.width;
    double sh =spaceObject.height;

    // Validate impact X
    double distanceX = (mx-sx).abs();
    double width = mx<sx?mw:sw;
    if(distanceX>width) return false;

    // Validate impact Y
    double distanceY = (my-sy).abs();
    double height = my<sy?mh:sh;
    if(distanceY>height) return false;

    // Ok validate impact
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new GestureDetector(
      onTapDown: (TapDownDetails details) => _onTapDown(details),
      onVerticalDragDown: (DragDownDetails details) => _onDragDown(details),
      onVerticalDragUpdate: (DragUpdateDetails details) =>
          _onDragUpdate(details),
      onVerticalDragEnd: (DragEndDetails details) => _navigationEnd(),
      onVerticalDragCancel: () => _navigationEnd(),
      onHorizontalDragDown: (DragDownDetails details) => _onDragDown(details),
      onHorizontalDragUpdate: (DragUpdateDetails details) =>
          _onDragUpdate(details),
      onHorizontalDragEnd: (DragEndDetails details) => _navigationEnd(),
      onHorizontalDragCancel: () => _navigationEnd(),
      onTapUp: (TapUpDetails details) => _onTapUp(details),
      child: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/maxresdefault.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: new Stack(
          fit: StackFit.passthrough,
          children: spaceObjectsPositionedForTurn,

        ),
      ),
    );
  }

  _onTapDown(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    tapX = x;
    tapY = y;
  }

  _onTapUp(TapUpDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    _navigationEnd();
  }

  _onDragDown(DragDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    tapX = x;
    tapY = y;
  }

  _onDragUpdate(DragUpdateDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    tapX = x;
    tapY = y;
  }

  _navigationEnd() {
    tapX = null;
    tapY = null;
  }
}
