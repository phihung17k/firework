import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class ChainBulletPainter extends CustomPainter {
  late double totalDistance;
  late double currentDistance;
  late int totalPoint;
  late double angle;
  late bool isDeleted;
  late double radiusOfBullet;
  late double scaleSpace;
  late List<Color> colors;

  ChainBulletPainter({
    required this.totalDistance,
    required this.currentDistance,
    required this.angle,
    this.totalPoint = 6,
    this.isDeleted = false,
    this.radiusOfBullet = 5,
    this.scaleSpace = 1,
    this.colors = const [Colors.red, Colors.white],
  });

  @override
  void paint(Canvas canvas, Size size) {
    // delete the last points when explosion (if any)
    if (isDeleted) {
      return;
    }

    // number of points to explosion = totalPoint - changedPointLevel
    // changedPointLevel: reduce (for end animate) or raise (for start animate)
    // ex:
    // Reduce: changedPointLevel == totalPoint => 1 point to explosion
    // changedPointLevel > totalPoint => 0 point to explosion (losting effect)
    int currentPoint = 0;
    int changedPoint = totalPoint - 1;

    // ex: totalDistance = 800
    // distanceForStartReducing = 600
    // distanceForStartReducing = 200
    // animate: start ---------------> end
    //        1 point --> 6 points --> 1 point
    double distanceForStartReducing = totalDistance * 3 / 4;
    double distanceForEndRaising = totalDistance * 1 / 4;

    // Raise
    if (currentDistance < distanceForEndRaising) {
      // subDistanceForRaisingPoint = 200 / level of raising points
      double subDistanceForRaisingPoint = distanceForEndRaising / changedPoint;

      int raisedPoint = 0;
      while (currentDistance - subDistanceForRaisingPoint * raisedPoint > 0) {
        raisedPoint++;
      }
      currentPoint += raisedPoint;
    } else if (currentDistance >= distanceForEndRaising &&
        currentDistance <= distanceForStartReducing) {
      currentPoint = totalPoint;
    }
    // Reduce
    else if (currentDistance > distanceForStartReducing) {
      currentPoint = totalPoint;
      // distanceForReducingPoint = 800 - 600 = 200
      // subDistanceForReducingPoint = 200 / level of reducing points
      double distanceForReducingPoint =
          totalDistance - distanceForStartReducing;
      double subDistanceForReducingPoint =
          distanceForReducingPoint / changedPoint;

      int lostPoint = 0;
      while (currentDistance - subDistanceForReducingPoint * lostPoint >
          distanceForStartReducing) {
        lostPoint++;
      }
      currentPoint -= lostPoint;
    }

    List<Offset> points = [];
    for (var i = 0; i < currentPoint; i++) {
      if (points.isEmpty) {
        // add first point
        points.add(Offset(size.width / 2, size.height - currentDistance));
      } else {
        points.add(points[0].translate(0, (radiusOfBullet - 1) * i));
      }
    }

    // when total points of rocket = 0 before explosion => Don't paint any point
    if (points.isEmpty) {
      return;
    }

    var fPoint = points[0];
    var lPoint = currentPoint > 0 ? points[currentPoint - 1] : points[0];

    // add gradient color for rocket (all points)
    Gradient gradient = LinearGradient(
      colors: colors,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    var paint = getPaint(strokeWidth: radiusOfBullet)
      ..shader = gradient.createShader(Rect.fromCenter(
          center: Offset(fPoint.dx, (fPoint.dy + lPoint.dy) / 2),
          width: size.width,
          height: lPoint.dy - fPoint.dy));

    // paint
    double alphaRadian = angle * pi / 180;
    canvas.transform((Matrix4.identity()
          ..rotateZ(alphaRadian)
          ..scale(scaleSpace))
        .storage);
    canvas.drawPoints(PointMode.points, points, paint);
  }

  @override
  bool shouldRepaint(covariant ChainBulletPainter oldDelegate) {
    return oldDelegate.currentDistance != currentDistance ||
        oldDelegate.isDeleted != isDeleted ||
        oldDelegate.radiusOfBullet != radiusOfBullet;
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
