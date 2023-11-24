import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class BulletPainter extends CustomPainter {
  double? totalDistance;
  double? currentDistance;
  bool? isDeleted;

  BulletPainter({
    this.totalDistance = 800,
    this.currentDistance = 0,
    this.isDeleted = false,
  });

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

    // number of points to explosion = totalPoint - changedPointLevel
    // changedPointLevel: reduce (for end animate) or raise (for start animate)
    // ex:
    // Reduce: changedPointLevel == totalPoint => 1 point to explosion
    // changedPointLevel > totalPoint => 0 point to explosion (losting effect)
    int totalPoint = 6;
    int currentPoint = 1;
    int changedPoint = totalPoint - 1;

    // ex: totalDistance = 800
    // distanceForStartReducing = 600
    // distanceForStartReducing = 200
    // animate: start ---------------> end
    //        1 point --> 6 points --> 1 point
    double distanceForStartReducing = totalDistance! * 3 / 4;
    double distanceForEndRaising = totalDistance! * 1 / 4;

    // Raise
    if (currentDistance! < distanceForEndRaising) {
      // subDistanceForRaisingPoint = 200 / level of raising points
      double subDistanceForRaisingPoint = distanceForEndRaising / changedPoint;

      int raisedPoint = 0;
      while (currentDistance! - subDistanceForRaisingPoint * raisedPoint > 0) {
        raisedPoint++;
      }
      currentPoint += raisedPoint;
    } else if (currentDistance! >= distanceForEndRaising &&
        currentDistance! <= distanceForStartReducing) {
      currentPoint = totalPoint;
    }
    // Reduce
    else if (currentDistance! > distanceForStartReducing) {
      currentPoint = totalPoint;
      // distanceForReducingPoint = 800 - 600 = 200
      // subDistanceForReducingPoint = 200 / level of reducing points
      double distanceForReducingPoint =
          totalDistance! - distanceForStartReducing;
      double subDistanceForReducingPoint =
          distanceForReducingPoint / changedPoint;

      int lostPoint = 0;
      while (currentDistance! - subDistanceForReducingPoint * lostPoint >
          distanceForStartReducing) {
        lostPoint++;
      }
      currentPoint -= lostPoint;
    }

    List<Offset> points = [];
    for (var i = 0; i < currentPoint; i++) {
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
    var lPoint = currentPoint > 0 ? points[currentPoint - 1] : points[0];

    // add gradient color for rocket (all points)
    rocketPaint = rocketPaint
      ..shader = gradient.createShader(Rect.fromCenter(
          center: Offset(fPoint.dx, (fPoint.dy + lPoint.dy) / 2),
          width: size.width,
          height: lPoint.dy - fPoint.dy));

    // paint
    List<double> angles = List.generate(40, (index) => index * 10);
    for (var angle in angles) {
      canvas.save();
      double alphaRadian = angle * pi / 180;
      canvas.transform((Matrix4.identity()
            // ..setEntry(3, 0, perX)
            // ..setEntry(3, 1, perY)
            // ..setEntry(3, 2, 0.001)
            // ..rotateX(roX * pi / 180)
            // ..rotateY(roY * pi / 180)
            // ..translate(x, -y)
            ..rotateZ(alphaRadian))
          .storage);

      canvas.drawPoints(PointMode.points, points, rocketPaint);
      canvas.restore();
    }
    // var paintCurve = Paint()
    //   ..color = Colors.amber
    //   ..strokeWidth = 10
    //   ..strokeCap = StrokeCap.round;

    // Path path = Path()
    //   ..moveTo(fPoint.dx, fPoint.dy)
    //   ..relativeQuadraticBezierTo(100, -350, 150, -50);
    // var listPoints = drawPointsFromPath(path);
    // canvas.drawPoints(PointMode.points, listPoints, paintCurve);
  }

  List<Offset> drawPointsFromPath(Path path) {
    // double dotWidth = 1;
    double dotSpace = 9;
    double distance = 0.0;
    List<Offset> list = [];
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        var tangent = pathMetric.getTangentForOffset(distance);
        var point = tangent!.position;
        var tempPoint = Offset(point.dx, point.dy);
        list.add(tempPoint);
        // distance += dotWidth;
        distance += dotSpace;
      }
    }
    return list;
  }

  @override
  bool shouldRepaint(BulletPainter oldDelegate) {
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
