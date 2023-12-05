import 'package:flutter/material.dart';

class ExplosionPainter extends CustomPainter {
  final Animation<double> explosionEffectAnimation;

  ExplosionPainter({required this.explosionEffectAnimation})
      : super(repaint: explosionEffectAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = explosionEffectAnimation.value;

    double width = size.width;
    double height = size.height;
    double midWidth = width / 2;
    double midHeight = height / 2;

    var explosionPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..color = Colors.white
      // ..blendMode = BlendMode.clear //sang trang
      // ..blendMode = BlendMode.colorDodge
      // ..blendMode = BlendMode.difference
      // ..blendMode = BlendMode.exclusion //ben tren

      // 4 colors are nice
      // ..blendMode = BlendMode.hardLight //ben tren
      // ..blendMode = BlendMode.lighten
      // ..blendMode = BlendMode.luminosity //sang trang
      ..blendMode = BlendMode.plus

      // ..blendMode = BlendMode.screen
      // ..blendMode = BlendMode.src
      // ..blendMode = BlendMode.srcATop
      // ..blendMode = BlendMode.srcOut //sang trang
      // ..blendMode = BlendMode.srcOver
      // ..blendMode = BlendMode.xor //sang trang
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawCircle(Offset(midWidth, midHeight), radius, explosionPaint);
  }

  @override
  bool shouldRepaint(covariant ExplosionPainter oldDelegate) {
    return false;
  }
}
