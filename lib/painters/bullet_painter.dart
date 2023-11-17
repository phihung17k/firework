import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class BulletPainter extends CustomPainter {
  double? increment;

  BulletPainter({this.increment = 0});

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    double midWidth = width / 2;
    double midHeight = height / 2;

    var bulletPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 15
      ..style = PaintingStyle.fill
      ..color = Colors.red;

    List<Offset> offsets = [
      Offset(midWidth + increment! * cos(pi / 3),
          midHeight - increment! * sin(pi / 3))
    ];
    canvas.drawPoints(PointMode.points, offsets, bulletPaint);
  }

  @override
  bool shouldRepaint(BulletPainter oldDelegate) {
    return increment != oldDelegate.increment;
  }
}
