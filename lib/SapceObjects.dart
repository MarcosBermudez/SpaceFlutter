import 'package:flutter/material.dart';

class HasTurn {
  Positioned performTurn(int deltaTimeSinceLastTurn, double tapX, double tapY) => null;

  bool isMissile() => false;

  void impacted(HasTurn object) {}

  bool isGoneOfSpace(double width, double height) => true;

  double lastTop = 100.0;
  double lastLeft = 100.0;
  double width = 10.0;
  double height = 15.0;
}

class Spaceship extends StatelessWidget implements HasTurn {
  Spaceship([this.color = Colors.blue]);

  final Color color;
  final int spaceshipSpeed = 100; // In pixels by second

  // Navigation variables
  double lastTop = 300.0;
  double lastLeft = 150.0;
  double width = 50.0;
  double height = 50.0;
  Positioned lastPosition;

  //Painter
  SpaceshipPainter painter = new SpaceshipPainter(50.toDouble());

  @override
  Positioned performTurn(int deltaTimeSinceLastTurn, double tapX, double tapY) {
    if (lastPosition != null && tapX != null) {
      double oldTop = lastPosition.top;
      double oldLeft = lastPosition.left;

      int distanceMoved = ((spaceshipSpeed * deltaTimeSinceLastTurn) /1000).round();

      // Calculate new position
      lastTop =
          tapY > oldTop ? lastTop + distanceMoved : lastTop - distanceMoved;
      lastLeft = tapX > oldLeft
          ? lastLeft + distanceMoved
          : lastLeft - distanceMoved;

      // If distance is less than we can move, move directly to target
      if((oldTop-tapY).abs()<distanceMoved) lastTop=tapY;
      if((oldLeft-tapX).abs()<distanceMoved) lastLeft=tapX;
    }


    Positioned newPosition =
        new Positioned(top: lastTop, left: lastLeft, child: this);
    lastPosition = newPosition;
    return newPosition;
  }

  @override
  bool isMissile() => false;

  @override
  bool isGoneOfSpace(double width, double height) => false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    painter.color = color;
    return new CustomPaint(
      size: new Size(width, height),
      painter: painter,
    );
  }

  @override
  void impacted(HasTurn object) {
    painter.color = Colors.black;
  }
}

class SpaceshipPainter extends CustomPainter {
  static const barWidth = 50.0;

  SpaceshipPainter(this.barHeight);

  final double barHeight;
  Color color = Colors.blue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = new Paint()
      ..color = this.color
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      new Rect.fromLTWH(
        (size.width - barWidth) / 2.0,
        size.height - barHeight,
        barWidth,
        barHeight,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(SpaceshipPainter old) => color != old.color;
}

class Missile extends StatelessWidget implements HasTurn {
  Missile([this.color = Colors.red]);

  final Color color;
  final int speed = 150;// Speed in pixels by second

  double lastTop = 0.0;
  double lastLeft = 100.0;
  double width = 10.0;
  double height = 15.0;

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      size: new Size(width, height),
      painter: new MissilePainter(color),
    );
  }

  @override
  Positioned performTurn(int deltaTimeSinceLastTurn, double tapX, double tapY) {

    int distanceMoved = ((speed * deltaTimeSinceLastTurn) /1000).round();

    lastTop = lastTop + distanceMoved;

    return new Positioned(top: lastTop, left: lastLeft, child: this);
  }

  @override
  bool isMissile() => true;

  @override
  bool isGoneOfSpace(double width, double height) => lastTop > height;

  @override
  void impacted(HasTurn object) {
    // TODO: implement impacted
  }
}

class MissilePainter extends CustomPainter {
  static const barWidth = 10.0;
  static const barHeight = 15.0;

  MissilePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = new Paint()
      ..color = this.color
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      new Rect.fromLTWH(
        (size.width - barWidth) / 2.0,
        size.height - barHeight,
        barWidth,
        barHeight,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(MissilePainter old) => false;
}
