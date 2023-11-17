import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  final double radius;

  CirclePainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    double midWidth = width / 2;
    double midHeight = height / 2;

    var circlePaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..color = Colors.black;
    canvas.drawCircle(Offset(midWidth, midHeight), radius, circlePaint);

    var axisPaint = circlePaint..strokeWidth = 2;
    canvas.drawLine(Offset(midWidth, 0), Offset(midWidth, height), axisPaint);
    canvas.drawLine(Offset(0, midHeight), Offset(width, midHeight), axisPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
