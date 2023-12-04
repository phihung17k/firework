import 'dart:ui';

import 'package:flutter/material.dart';

class ChainBulletPrototypePainter extends CustomPainter {
  double? roX;
  double? roY;
  double? roZ;

  ChainBulletPrototypePainter({this.roX = 0, this.roY = 0, this.roZ = 0});

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    double midWidth = width / 2;
    double midHeight = height / 2;

    var rocketPaint = getPaint();
    var body1Paint = getPaint(color: Colors.red.shade400);
    var body2Paint = getPaint(color: Colors.red.shade300);
    var body3Paint = getPaint(color: Colors.red.shade200);
    var body4Paint = getPaint(color: Colors.red.shade100);

    double radius = 20;
    var rocket = Offset(midWidth, midHeight);
    var body1 = rocket.translate(0, radius);
    var body2 = rocket.translate(0, radius * 2);
    var body3 = rocket.translate(0, radius * 3);
    var body4 = rocket.translate(0, radius * 4);

    // canvas.save();
    //[
    //   1, 0, 0, 0,
    //   0, 1, 0, 0,
    //   0, 0, 1, 0,
    //   0, 0, 0, 1,
    // ]
    // Z: not affect in 2D
    // (col, row)
    // scale X, Y, Z -> (0, 0), (1, 1), (2, 2)
    // translate X, Y, Z -> (3, 0), (3, 1), (3, 2)
    // rotate
    // perspective X, Y, Z -> (0, 3), (1, 3), (2, 3)
    // ALL = scale + translate + rotate -> (3, 3)
    // double perX = 0.000;
    // double perY = 0.00;
    // double perZ = 0.000;
    // double roX = this.roX!; //rotate top -> bottom
    // double roY = this.roY!; //rotate left -> right
    // double roZ = this.roZ!;
    // debugPrint("roX: $roX -- roY: $roY");
    canvas.transform((Matrix4.identity()
        // ..setEntry(3, 0, perX)
        // ..setEntry(3, 1, perY)
        // ..setEntry(3, 2, perZ)
        // ..rotateX(roX * pi / 180)
        // ..rotateY(roY * pi / 180)
        // ..rotateZ(roZ * pi / 180)
        )
        .storage);

    canvas.drawPoints(PointMode.points, [body4], body4Paint);
    canvas.drawPoints(PointMode.points, [body3], body3Paint);
    canvas.drawPoints(PointMode.points, [body2], body2Paint);
    canvas.drawPoints(PointMode.points, [body1], body1Paint);
    canvas.drawPoints(PointMode.points, [rocket], rocketPaint);

    // canvas.drawRect(
    //     Rect.fromCenter(
    //         center: Offset(midWidth, midHeight), width: 300, height: 300),
    //     getPaint(color: Colors.red, strokeWidth: 10));
    // canvas.drawRect(
    //     Rect.fromCenter(
    //         center: Offset(midWidth, midHeight), width: 200, height: 200),
    //     getPaint(color: Colors.yellow, strokeWidth: 10)
    //       ..shader = ui.Gradient.linear(
    //           Offset(midWidth - 100, midHeight - 100),
    //           Offset(midWidth + 100, midHeight + 100),
    //           [Colors.amber, Colors.cyan]));
    // canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Paint getPaint({Color color = Colors.red, double strokeWidth = 30}) {
    return Paint()
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.fill
      ..color = color;
  }
}
