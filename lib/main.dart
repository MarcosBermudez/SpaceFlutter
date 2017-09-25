import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spaceflutter/SapceObjects.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends WidgetsApp {
  WidgetsApp app;

  static double height, width;

  MyApp()
      : super(
          initialRoute: '/',
          onGenerateRoute: myRouteFactory,
          navigatorObservers: [],
          color: Colors.black,
        );

  static MenuPage menu = new MenuPage();

  static Route<dynamic> myRouteFactory(RouteSettings settings) =>
      new PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) =>
              settings.name == '/' ? menu : new SpacePage());
}

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        onTapUp: ((_) => Navigator.of(context).pushNamed('/space')),
      ),
    );
  }
}

class SpacePage extends StatefulWidget {
  SpacePage({Key key}) : super(key: key);

  @override
  _SpacePageState createState() => new _SpacePageState();
}

class _SpacePageState extends State<SpacePage> {
  final Duration wakeUpDuration = new Duration(milliseconds: 5);

  final Spaceship ship = new Spaceship();

  var tapX = null;
  var tapY = null;
  Timer t;

  static int fps = 30;
  static int timePerTurn = (1000 / fps).round();
  int delta = 0, timer = 0, now = 0;
  int lastTime;

  List<HasTurn> spaceObjects = null;
  List<Positioned> spaceObjectsPositionedForTurn = [];

  bool running = false;

  int numMissiles = 3;

  int points = 0;

  @override
  void initState() {
    super.initState();

    //Initialize start
    spaceObjects = [ship];

    // Init last time
    lastTime = new DateTime.now().millisecondsSinceEpoch;

    // Init timer
    t = new Timer.periodic(wakeUpDuration, (t) => onWakeUp());
  }

  void onWakeUp() {
    if (running) {
      now = new DateTime.now().millisecondsSinceEpoch;
      delta = now - lastTime;
      timer = timer + delta;
      lastTime = now;
      if (timer >= timePerTurn) {
        turn(timer);
        timer = 0;
      }
    }
  }

  void turn(int deltaTimeSinceLastTurn) {
    if (running) {
      List<HasTurn> ships = spaceObjects.where((o) => !o.isMissile()).toList();
      List<HasTurn> missiles =
          spaceObjects.where((o) => o.isMissile()).toList();

      // Calculate missile impacts
      missiles.forEach(
          (HasTurn m) => ships.where((s) => isImpact(m, s)).forEach((s) {
                s.impacted(m);
                m.impacted(s);
              }));

      // Calculate new position for each of the space objects
      setState(() => spaceObjectsPositionedForTurn = spaceObjects
          .map((t) => t.performTurn(deltaTimeSinceLastTurn, tapX, tapY))
          .toList());

      // Remove old space objects
      spaceObjects.removeWhere((HasTurn t) {
        bool isGone = t.isGoneOfSpace(MyApp.width, MyApp.height);
        if (t.isMissile() && isGone) {
          numMissiles += 1;
          points += 1;
        }
        return isGone;
      });

      // GamePlay Add missiles
      if (spaceObjects.length < numMissiles - 1 && running) {
        // There is 5% of chance to add new missile
        if (new Random().nextInt(100) < 3) {
          spaceObjects.add(new Missile(MyApp.width, MyApp.height));
        }
      }

      // Test if game is over, when sno ship is found
      if (spaceObjects.where((HasTurn t) => !t.isMissile()).length == 0) {
        running = false;
        t.cancel();
        spaceObjectsPositionedForTurn = [
          new Positioned(
              top: (MyApp.height - 60) / 2,
              left: (MyApp.width - 180) / 2,
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
        ];

      }
    }
  }

  bool isImpact(HasTurn missile, HasTurn spaceObject) {
    // TODO
    double mx = missile.lastLeft;
    double my = missile.lastTop;
    double mw = missile.width;
    double mh = missile.height;

    double sx = spaceObject.lastLeft;
    double sy = spaceObject.lastTop;
    double sw = spaceObject.width;
    double sh = spaceObject.height;

    // Validate impact X
    double distanceX = (mx - sx).abs();
    double width = mx < sx ? mw : sw;
    if (distanceX > width) return false;

    // Validate impact Y
    double distanceY = (my - sy).abs();
    double height = my < sy ? mh : sh;
    if (distanceY > height) return false;

    // Ok validate impact
    return true;
  }

  @override
  Widget build(BuildContext context) {
    running = true;
    if (MyApp.width == null) {
      MyApp.height = MediaQuery.of(context).size.height;
      MyApp.width = MediaQuery.of(context).size.width;
      print(
          "Size is " + MyApp.height.toString() + "," + MyApp.width.toString());
    }
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
