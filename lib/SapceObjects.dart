import 'package:flutter/material.dart';

class HasTurn {
  Positioned performTurn(double tapX, double tapY) => null;
}

class Spaceship extends StatelessWidget implements HasTurn {
  Spaceship([this.color = Colors.blue]);

  final Color color;
  final int spaceshipSpeed = 1;

  // Navigation variables
  double fromTop = 300.toDouble();
  double fromLeft = 150.toDouble();
  Positioned oldPosition;

  @override
  Positioned performTurn(double tapX, double tapY) {
    if (oldPosition != null && tapX != null) {
      double oldTop = oldPosition.top;
      double oldLeft = oldPosition.left;

      // Calculate new position
      fromTop =
          tapY > oldTop ? fromTop + spaceshipSpeed : fromTop - spaceshipSpeed;
      fromLeft = tapX > oldLeft
          ? fromLeft + spaceshipSpeed
          : fromLeft - spaceshipSpeed;
    }
    Positioned newPosition =
        new Positioned(top: fromTop, left: fromLeft, child: this);
    oldPosition = newPosition;
    return newPosition;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      size: new Size(50.0, 50.0),
      painter: new SpaceshipPainter(50.toDouble(), color),
    );
  }
}

class SpaceshipPainter extends CustomPainter {
  static const barWidth = 50.0;

  SpaceshipPainter(this.barHeight, this.color);

  final double barHeight;
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
  bool shouldRepaint(SpaceshipPainter old) => barHeight != old.barHeight;
}

class Missile extends StatelessWidget implements HasTurn {
  Missile([this.color = Colors.red]);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      size: new Size(10.0, 15.0),
      painter: new MissilePainter(color),
    );
  }

  @override
  Positioned performTurn(double tapX, double tapY) {
    return new Positioned(top: 100.0, left: 100.0, child: this);
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
