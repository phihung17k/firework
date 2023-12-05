import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class ChainBulletV2Painter extends CustomPainter {
  late double totalDistance;
  late double currentDistance;
  late int totalPoint;
  late double angle;
  late bool isDeleted;
  late double radiusOfBullet;
  late double scaleSpace;
  late Animation<double> bezierAnimation;

  ChainBulletV2Painter({
    required this.totalDistance,
    required this.currentDistance,
    required this.angle,
    this.totalPoint = 6,
    this.isDeleted = false,
    this.radiusOfBullet = 5,
    this.scaleSpace = 1,
    required this.bezierAnimation,
  }) : super(repaint: bezierAnimation);

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
    int currentPoint = 8;
    int changedPoint = totalPoint - 1;

    // ex: totalDistance = 800
    // distanceForStartReducing = 600
    // distanceForStartReducing = 200
    // animate: start ---------------> end
    //        1 point --> 6 points --> 1 point
    double distanceForStartReducing = totalDistance * 3 / 4;
    double distanceForEndRaising = totalDistance * 1 / 4;

    // // Raise
    // if (currentDistance < distanceForEndRaising) {
    //   // subDistanceForRaisingPoint = 200 / level of raising points
    //   double subDistanceForRaisingPoint = distanceForEndRaising / changedPoint;

    //   int raisedPoint = 0;
    //   while (currentDistance - subDistanceForRaisingPoint * raisedPoint > 0) {
    //     raisedPoint++;
    //   }
    //   currentPoint += raisedPoint;
    // } else if (currentDistance >= distanceForEndRaising &&
    //     currentDistance <= distanceForStartReducing) {
    //   currentPoint = totalPoint;
    // }
    // // Reduce
    // else if (currentDistance > distanceForStartReducing) {
    //   currentPoint = totalPoint;
    //   // distanceForReducingPoint = 800 - 600 = 200
    //   // subDistanceForReducingPoint = 200 / level of reducing points
    //   double distanceForReducingPoint =
    //       totalDistance - distanceForStartReducing;
    //   double subDistanceForReducingPoint =
    //       distanceForReducingPoint / changedPoint;

    //   int lostPoint = 0;
    //   while (currentDistance - subDistanceForReducingPoint * lostPoint >
    //       distanceForStartReducing) {
    //     lostPoint++;
    //   }
    //   currentPoint -= lostPoint;
    // }

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
      colors: [Colors.red, Colors.red.shade50],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    var paint = getPaint(strokeWidth: radiusOfBullet)
      ..shader = gradient.createShader(Rect.fromCenter(
          center: Offset(fPoint.dx, (fPoint.dy + lPoint.dy) / 2),
          width: size.width,
          height: lPoint.dy - fPoint.dy));

    // paint
    canvas.save();
    double alphaRadian = angle * pi / 180;
    canvas.transform((Matrix4.identity()
          // ..setEntry(3, 0, perX)
          // ..setEntry(3, 1, perY)
          // ..setEntry(3, 2, 0.001)
          // ..rotateX(roX * pi / 180)
          // ..rotateY(roY * pi / 180)
          // ..translate(x, -y)
          ..rotateZ(alphaRadian)
          ..scale(scaleSpace))
        .storage);
    // canvas.drawPoints(PointMode.points, points, paint);
    canvas.restore();

    var paintCurve = Paint()
      ..color = Colors.amber
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Offset center = Offset(size.width / 2, size.height / 2);
    Offset p0 = center;
    Offset p1 = p0.translate(150, -350);
    Offset p2 = p0.translate(250, -350);
    Offset p3 = p0.translate(300, -200);
    Path path = Path()
      ..moveTo(p0.dx, p0.dy)
      ..cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, p3.dx, p3.dy);
    // ..relativeCubicTo(150, -350, 250, -350, 300, -200);
    // ..relativeQuadraticBezierTo(100, -350, 150, -50);
    var listPoints = drawPointsFromPath(path);
    canvas.drawPoints(PointMode.points, listPoints, paintCurve);

    Paint paintPoint = paintCurve
      ..color = Colors.cyan
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    double t = bezierAnimation.value;
    List<Offset> pointList = [];
    for (var i = 0; i < 10; i++) {
      var point = calculatePosition(p0, p1, p2, p3, t, i);
      pointList.add(point);
    }

    // canvas.drawCircle(point0, 10, paintPoint);
    // canvas.drawCircle(point1, 10, paintPoint);
    canvas.drawPoints(PointMode.points, pointList, paintPoint);
    // canvas.drawArc(rect, pi, pi + pi, false, paintCurve);
  }

  Offset calculatePosition(
      Offset p0, Offset p1, Offset p2, Offset p3, double t, int index) {
    double temp = t - index * 0.01;
    if (temp < 0) {
      temp = 0;
    }

    // when animation end, first point achive the end of bezier
    if (t == 1 && index != 0) {
      temp += index * 0.01;
    }

    double mt = 1 - temp; //minus t
    // bezier equation
    // P = (1−t)^3 * P0 + 3 * (1−t)^2 *t* P1 + 3*(1−t)* t^2 * P2 + t3 * P3
    num b0 = pow(mt, 3);
    num b1 = 3 * pow(mt, 2) * temp;
    num b2 = 3 * mt * pow(temp, 2);
    num b3 = pow(temp, 3);
    double x = b0 * p0.dx + b1 * p1.dx + b2 * p2.dx + b3 * p3.dx;
    double y = b0 * p0.dy + b1 * p1.dy + b2 * p2.dy + b3 * p3.dy;
    return Offset(x, y);
  }

  List<Offset> drawPointsFromPath(Path path) {
    // double dotWidth = 1;
    double dotSpace = 3;
    double distance = 0.0;
    List<Offset> list = [];
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        Tangent? tangent = pathMetric.getTangentForOffset(distance);
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
  bool shouldRepaint(covariant ChainBulletV2Painter oldDelegate) {
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
