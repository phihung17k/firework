import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class ChainBulletV2Painter extends CustomPainter {
  late Animation<double> bezierAnimation;
  late int totalPoint;
  late bool isDeleted;
  late double radiusOfBullet;
  late Offset p1Translate;
  late Offset p2Translate;
  late Offset p3Translate;
  late double scaleSpace;
  late List<Color> colors;

  ChainBulletV2Painter({
    required this.bezierAnimation,
    required this.p1Translate,
    required this.p2Translate,
    required this.p3Translate,
    this.totalPoint = 30,
    this.isDeleted = false,
    this.radiusOfBullet = 5,
    this.scaleSpace = 1,
    this.colors = const [Colors.red, Colors.white],
  }) : super(repaint: bezierAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    // delete the last points when explosion (if any)
    if (isDeleted) {
      return;
    }

    Offset center = Offset(size.width / 2, size.height / 2);
    Offset p0 = center;
    Offset p1 = p0 + p1Translate;
    Offset p2 = p0 + p2Translate;
    Offset p3 = p0 + p3Translate;
    // for test
    // var paintCurve = Paint()
    //   ..color = Colors.amber
    //   ..strokeWidth = 1
    //   ..strokeCap = StrokeCap.round
    //   ..style = PaintingStyle.stroke;
    // Path path = Path()
    //   ..moveTo(p0.dx, p0.dy)
    //   ..cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, p3.dx, p3.dy);
    // var listPoints = drawPointsFromPath(path);
    // canvas.drawPoints(PointMode.points, listPoints, paintCurve);

    // paint chain bullet
    double t = bezierAnimation.value;
    List<Offset> points = [];
    double maxT = 1;
    double remainTime = maxT - 0.8; // 0.2
    double subRemainTime = remainTime / totalPoint; // 0.02
    int pointLost = 0;
    for (var i = 0; i < totalPoint; i++) {
      // totalPoint = 10
      // 0.85 - 0 * 0.02 = 0.85 > 0.8 -> lost i = 9
      // 0.85 - 1 * 0.02 = 0.83 > 0.8 -> lost i = 8
      // 0.85 - 2 * 0.02 = 0.81 > 0.8 -> lost i = 7
      // 0.85 - 3 * 0.02 = 0.79 < 0.8 -> pointList = 3 (lost 9 8 7)
      if (t - i * subRemainTime > 0.8) {
        pointLost++;
      }

      var point = calculatePosition(p0, p1, p2, p3, t, i);
      points.add(point);
    }

    // reduce point before end animation (explosion end)
    int remainPoints = points.length - pointLost;
    if (remainPoints == 0) {
      remainPoints = 1;
    }
    // before explosion started, remainPoints == 1 because of the above logic
    if (remainPoints > 0 && t == 0) {
      return;
    }
    points = points.take(remainPoints).toList();

    var fPoint = points[0];
    var lPoint = points[points.length - 1];

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

    canvas.scale(scaleSpace);
    canvas.drawPoints(PointMode.points, points, paint);
  }

  Offset calculatePosition(
      Offset p0, Offset p1, Offset p2, Offset p3, double t, int index) {
    // point 0 appear first
    // point 1 appear after point 0: 0.01s
    // ...
    double temp = t - index * 0.01;
    if (temp < 0) {
      temp = 0;
    }

    double mt = 1 - temp; //minus t
    // Quadratic bezier equation (4 points)
    // P = (1−t)^3 * P0 + 3 * (1−t)^2 *t* P1 + 3*(1−t)* t^2 * P2 + t3 * P3
    // bezier equation (3 points)
    // P = (1−t)^2 * P0 + 2*(1−t)*t* P1 + t^2 * P2

    // num b0 = pow(mt, 3);
    // num b1 = 3 * pow(mt, 2) * temp;
    // num b2 = 3 * mt * pow(temp, 2);
    // num b3 = pow(temp, 3);
    // double x = b0 * p0.dx + b1 * p1.dx + b2 * p2.dx + b3 * p3.dx;
    // double y = b0 * p0.dy + b1 * p1.dy + b2 * p2.dy + b3 * p3.dy;

    num b0 = pow(mt, 2);
    num b1 = 2 * mt * temp;
    num b2 = pow(temp, 2);
    double x = b0 * p0.dx + b1 * p1.dx + b2 * p3.dx;
    double y = b0 * p0.dy + b1 * p1.dy + b2 * p3.dy;
    return Offset(x, y);
  }

  // for test
  // List<Offset> drawPointsFromPath(Path path) {
  //   // double dotWidth = 1;
  //   double dotSpace = 1;
  //   double distance = 0.0;
  //   List<Offset> list = [];
  //   for (PathMetric pathMetric in path.computeMetrics()) {
  //     while (distance < pathMetric.length) {
  //       Tangent? tangent = pathMetric.getTangentForOffset(distance);
  //       var point = tangent!.position;
  //       var tempPoint = Offset(point.dx, point.dy);
  //       list.add(tempPoint);
  //       // distance += dotWidth;
  //       distance += dotSpace;
  //     }
  //   }
  //   return list;
  // }

  @override
  bool shouldRepaint(covariant ChainBulletV2Painter oldDelegate) {
    return oldDelegate.isDeleted != isDeleted ||
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
