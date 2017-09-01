import 'package:flutter/material.dart';


class Spaceship extends StatelessWidget {


  Spaceship([this.color = Colors.blue]);

  final Color color;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      size: new Size(50.0, 50.0),
      painter: new SpaceshipPainter(50.toDouble(),color),
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
