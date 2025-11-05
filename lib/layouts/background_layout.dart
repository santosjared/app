import 'package:flutter/material.dart';

class BackgroundLayout extends CustomPainter {
  final Color backgroundColor;
  final Color dotColor;
  final double dotRadius;
  final double spacing;

  BackgroundLayout({
    this.dotRadius = 8,
    this.spacing = 30,
    required this.backgroundColor,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = backgroundColor;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    final dotPaint = Paint()..color = dotColor;

    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
