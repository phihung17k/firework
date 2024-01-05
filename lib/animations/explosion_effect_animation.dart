import 'package:flutter/material.dart';

import '../painters/explosion_painter.dart';

class ExplosionEffectAnimation extends StatelessWidget {
  const ExplosionEffectAnimation({
    super.key,
    required this.explosionEffectAnimation,
  });

  final Animation<double> explosionEffectAnimation;

  @override
  Widget build(BuildContext context) {
    // debugPrint("ExplosionEffectAnimation");
    return RepaintBoundary(
      key: const ValueKey("repaint explosionEffectAnimation"),
      child: AnimatedBuilder(
        animation: explosionEffectAnimation,
        builder: (context, _) {
          return CustomPaint(
            key: const ValueKey("explosionEffectAnimation"),
            painter: ExplosionPainter(
                explosionEffectAnimation: explosionEffectAnimation),
          );
        },
      ),
    );
  }
}
