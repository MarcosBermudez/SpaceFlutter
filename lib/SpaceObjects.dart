import 'package:flutter/material.dart';
import 'dart:math';

// Images from
// https://opengameart.org/content/space-ship-construction-kit
// https://opengameart.org/content/25-special-effects-rendered-with-blender
class SpaceObject {
  Positioned calculateNextTurnPosition(
          int deltaTimeSinceLastTurn, double tapX, double tapY) =>
      null;

  bool isMissile() => false;

  void impacted(SpaceObject object) {}

  bool isGoneOfSpace(double width, double height) => true;

  double lastTop = 100.0;
  double lastLeft = 100.0;
  double width = 10.0;
  double height = 15.0;
}

class Spaceship extends StatefulWidget implements SpaceObject {

  final int spaceshipSpeed = 250; // In pixels by second

  // Navigation variables
  double lastTop = 300.0;
  double lastLeft = 150.0;
  Positioned lastPosition;

  // Size variables
  double width = 90.0;
  double height = 125.0;


  _ShipSpaceshipState state = new _ShipSpaceshipState();

  @override
  Positioned calculateNextTurnPosition(int deltaTimeSinceLastTurn, double tapX, double tapY) {
    if (lastPosition != null && tapX != null && !state.isImpacted()) {

      // Adjust navigation into the middle of plane
      double adjustedTapX=tapX-width/2 , adjustedTapY=tapY-height/2;

      double oldTop = lastPosition.top;
      double oldLeft = lastPosition.left;

      int distanceMoved =
          ((spaceshipSpeed * deltaTimeSinceLastTurn) / 1000).round();

      // Calculate new position
      lastTop =
          adjustedTapY > oldTop ? lastTop + distanceMoved : lastTop - distanceMoved;
      lastLeft =
          adjustedTapX > oldLeft ? lastLeft + distanceMoved : lastLeft - distanceMoved;

      // If distance is less than we can move, move directly to target
      if ((oldTop - adjustedTapY).abs() < distanceMoved) lastTop = adjustedTapY;
      if ((oldLeft - adjustedTapX).abs() < distanceMoved) lastLeft = adjustedTapX;
    }

    // Inform of new turn in state;
    state.performTurn(deltaTimeSinceLastTurn);

    Positioned newPosition =
        new Positioned(top: lastTop, left: lastLeft, child: this);
    lastPosition = newPosition;
    return newPosition;
  }

  @override
  bool isMissile() => false;

  @override
  bool isGoneOfSpace(double width, double height) => state.isDestroyed();

  @override
  void impacted(SpaceObject object) {
      state.impacted();
  }

  @override
  State<Spaceship> createState() {
    return state;
  }
}

class _ShipSpaceshipState extends State<Spaceship> {
  int impactedTurn = 0;

  int deltaSinceLastState = 0;
  int timePerState = 50;

  void impacted() {
    if (!isImpacted()) {
      setState(() {
        impactedTurn = impactedTurn + 1;
      });
    }
  }

  performTurn(int deltaTimeSinceLastTurn) {
    deltaSinceLastState = deltaSinceLastState + deltaTimeSinceLastTurn;
    if (isImpacted() && deltaSinceLastState > timePerState) {
      setState(() {
        impactedTurn = impactedTurn + 1;
        deltaSinceLastState = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Image image = new Image.asset('assets/images/ships/yelow0/1.png');
    if (isImpacted() && !isDestroyed()) {
      image = new Image.asset(
          'assets/images/ships/yelow0/' + impactedTurn.toString() + '.png');
      impactedTurn++;
    }
    return image;
  }

  bool isImpacted() => impactedTurn != 0;

  bool isDestroyed() => impactedTurn == 10;
}

class Missile extends StatelessWidget implements SpaceObject {

  final Color color;
  final int speed = 150; // Speed in pixels by second

  double lastTop = 0.0;
  double lastLeft = 100.0;
  double width = 10.0;
  double height = 22.0;
  bool explosed = false;

  Missile(double width, double height,[this.color = Colors.red]){
    lastLeft = new Random().nextInt(width.toInt())/1.0;
  }

  @override
  Widget build(BuildContext context) {
    return new Image.asset("assets/images/ships/misile.png");
  }

  @override
  Positioned calculateNextTurnPosition(int deltaTimeSinceLastTurn, double tapX, double tapY) {
    int distanceMoved = ((speed * deltaTimeSinceLastTurn) / 1000).round();

    lastTop = lastTop + distanceMoved;

    return new Positioned(top: lastTop, left: lastLeft, child: this);
  }

  @override
  bool isMissile() => true;

  @override
  bool isGoneOfSpace(double width, double height) => lastTop > height || isExplosed();

  @override
  void impacted(SpaceObject object) {
    explosed=true;
  }

  bool isExplosed() => explosed;
}
