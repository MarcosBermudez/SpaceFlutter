import 'package:flutter/material.dart';
import 'package:duende/main.dart';

class HasTurn {
  Positioned performTurn(double tapX, double tapY) => null;

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
  final int spaceshipSpeed = 1;

  // Navigation variables
  double lastTop = 300.0;
  double lastLeft = 150.0;
  double width = 50.0;
  double height = 50.0;
  Positioned lastPosition;

  //Painter
  SpaceshipPainter painter = new SpaceshipPainter(50.toDouble());

  @override
  Positioned performTurn(double tapX, double tapY) {
    if (lastPosition != null && tapX != null) {
      double oldTop = lastPosition.top;
      double oldLeft = lastPosition.left;

      // Calculate new position
      lastTop =
          tapY > oldTop ? lastTop + spaceshipSpeed : lastTop - spaceshipSpeed;
      lastLeft = tapX > oldLeft
          ? lastLeft + spaceshipSpeed
          : lastLeft - spaceshipSpeed;
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
  final double speed = 1.0;

  double lastTop = 100.0;
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
  Positioned performTurn(double tapX, double tapY) {
    lastTop = lastTop + speed;
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
