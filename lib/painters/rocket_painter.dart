import 'dart:ui';

import 'package:flutter/material.dart';

class RocketPainter extends CustomPainter {
  double? totalDistance;
  double? currentDistance;
  bool? isDeleted;

  RocketPainter(
      {this.totalDistance = 800,
      this.currentDistance = 0,
      this.isDeleted = false});

  @override
  void paint(Canvas canvas, Size size) {
    // delete the last points when explosion (if any)
    if (isDeleted!) {
      return;
    }

    double radius = 10;
    var rocketPaint = getPaint(strokeWidth: radius);

    Gradient gradient = LinearGradient(
      colors: [Colors.red, Colors.red.shade50],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    // number of points to explosion = totalPoint - reducingPointLevel
    // ex: reducingPointLevel == totalPoint => 1 point to explosion
    // reducingPointLevel > totalPoint => 0 point to explosion (losting effect)
    int totalPoint = 6;
    int reducingPoint = 5;

    // ex: totalDistance = 800
    // distanceForStarting = 600
    // distanceForReducingPoint = 800 - 600 = 200
    // subDistanceForReducingPoint = 200 / level of reducing points
    double distanceForStarting = totalDistance! * 3 / 4;
    double distanceForReducingPoint = totalDistance! - distanceForStarting;
    double subDistanceForReducingPoint =
        distanceForReducingPoint / reducingPoint;

    if (currentDistance! > distanceForStarting) {
      int lostPoint = 0;
      while (currentDistance! - subDistanceForReducingPoint * lostPoint >
          distanceForStarting) {
        lostPoint++;
      }
      totalPoint -= lostPoint;
    }

    List<Offset> points = [];
    for (var i = 0; i < totalPoint; i++) {
      if (points.isEmpty) {
        // add first point
        points.add(Offset(size.width / 2, size.height - currentDistance!));
      } else {
        points.add(points[0].translate(0, (radius - 3) * i));
      }
    }

    // when total points of rocket = 0 before explosion => Don't paint any point
    if (points.isEmpty) {
      return;
    }

    var fPoint = points[0];
    var lPoint = totalPoint > 0 ? points[totalPoint - 1] : points[0];

    // add gradient color for rocket (all points)
    rocketPaint = rocketPaint
      ..shader = gradient.createShader(Rect.fromCenter(
          center: Offset(fPoint.dx, (fPoint.dy + lPoint.dy) / 2),
          width: size.width,
          height: lPoint.dy - fPoint.dy));

    canvas.drawPoints(PointMode.points, points, rocketPaint);
  }

  @override
  bool shouldRepaint(RocketPainter oldDelegate) {
    return true;
  }

  Paint getPaint({Color color = Colors.green, double strokeWidth = 35}) {
    return Paint()
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.fill
      ..color = color;
  }
}
