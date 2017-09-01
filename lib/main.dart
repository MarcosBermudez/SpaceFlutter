import 'dart:async';

import 'package:flutter/material.dart';
import 'package:duende/Spaceship.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final Duration turnDuration = new Duration(milliseconds: 5);
  final int step = 1;

  Timer t;
  double fromTop = 300.toDouble();
  double fromLeft = 150.toDouble();
  Positioned oldPosition;
  final Spaceship ship =  new Spaceship(Colors.green);

  var tapX = null;
  var tapY = null;

  List<Widget> childs = [];


  @override
  void initState() {
    super.initState();
    t = new Timer.periodic(turnDuration, (Timer tim)=>turn());
  }


  void turn(){

    setState((){
      if(oldPosition!=null && tapX!=null)
        {
          double oldTop = oldPosition.top;
          double oldleft = oldPosition.left;

          // Calculate new position
          fromTop = tapY>oldTop?fromTop+step:fromTop-step;
          fromLeft = tapX>oldleft?fromLeft+step:fromLeft-step;
        }
      Positioned newPosition = new Positioned(top: fromTop,left: fromLeft, child: ship);
      oldPosition = newPosition;
      childs = [
        newPosition,
      ];
      }
    );

  }


  @override
  Widget build(BuildContext context) {


    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new GestureDetector(
      onTapDown: (TapDownDetails details) => _onTapDown(details),
      onVerticalDragDown: (DragDownDetails details) => _onDragDown(details),
      onVerticalDragUpdate:  (DragUpdateDetails details) => _onDragUpdate(details),
      onVerticalDragEnd: (DragEndDetails details) => _navigationEnd(),
      onVerticalDragCancel: () => _navigationEnd(),
      onHorizontalDragDown: (DragDownDetails details) => _onDragDown(details),
      onHorizontalDragUpdate: (DragUpdateDetails details) => _onDragUpdate(details),
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
          children: childs,
        ),
      ),
    );
  }

  _onTapDown(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    tapX=x;
    tapY=y;
  }

  _onTapUp(TapUpDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    _navigationEnd();
  }

  _onDragDown(DragDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    tapX=x;
    tapY=y;
  }

  _onDragUpdate(DragUpdateDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    tapX=x;
    tapY=y;
  }

  _navigationEnd() {
    tapX = null;
    tapY = null;
  }


}


