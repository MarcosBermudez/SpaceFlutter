import 'dart:async';
import 'dart:math';

import 'package:spaceflutter/SpaceObjects.dart';
import 'package:spaceflutter/SpaceFlutterApplication.dart';
import 'package:spaceflutter/pages/SpacePage.dart';

class GamePlay {

  static final int fps = 30;
  static final int timePerTurn = (1000 / fps).round();
  int delta = 0, timer = 0, now = 0;
  int lastTime;

  Timer t;

  int numMissiles = 3, points = 0;
  List<SpaceObject> spaceObjects;

  SpacePageState _spacePageState;

  GamePlay(this._spacePageState);

  void initGamePlay() {

    // Initialize start ships
    spaceObjects = [new Spaceship()];

    // Initialize points
    points = 0;

    // Init last time
    lastTime = new DateTime.now().millisecondsSinceEpoch;

    // Init timer
    t = new Timer.periodic(new Duration(milliseconds: 5), (t) => onWakeUp());
  }

  void onWakeUp() {
      now = new DateTime.now().millisecondsSinceEpoch;
      delta = now - lastTime;
      timer = timer + delta;
      lastTime = now;
      if (timer >= timePerTurn) {
        turn(timer);
        timer = 0;
      }
  }

  void turn(int deltaTimeSinceLastTurn) {

    if (_spacePageState.mounted) {
      List<SpaceObject> ships =
          spaceObjects.where((o) => !o.isMissile()).toList();
      List<SpaceObject> missiles =
          spaceObjects.where((o) => o.isMissile()).toList();

      // Calculate missile impacts
      missiles.forEach(
          (SpaceObject m) => ships.where((s) => isImpact(m, s)).forEach((s) {
                s.impacted(m);
                m.impacted(s);
              }));

      // Calculate new position for each of the space objects
      _spacePageState.setSpaceObjects(
          spaceObjects
              .map((SpaceObject t) => t.calculateNextTurnPosition(deltaTimeSinceLastTurn,
                  _spacePageState.tapX, _spacePageState.tapY))
              .toList(),
          points);

      // Remove old space objects
      spaceObjects.removeWhere((SpaceObject t) {
        bool isGone = t.isGoneOfSpace(
            SpaceFlutterApplication.width, SpaceFlutterApplication.height);
        if (t.isMissile() && isGone) {
          numMissiles += 1;
          points += 1;
        }
        return isGone;
      });

      // GamePlay add new missiles
      if (spaceObjects.length < numMissiles - 1 && _spacePageState.mounted) {
        // There is 5% of chance to add new missile
        if (new Random().nextInt(100) < 5) {
          spaceObjects.add(new Missile(
              SpaceFlutterApplication.width, SpaceFlutterApplication.height));
        }
      }

      // Test if game is over, when no ship is found
      if (spaceObjects.where((SpaceObject t) => !t.isMissile()).length == 0) {
        t.cancel();
        _spacePageState.setGameOver(points);
      }
    }
  }

  static bool isImpact(SpaceObject missile, SpaceObject spaceObject) {
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
}
