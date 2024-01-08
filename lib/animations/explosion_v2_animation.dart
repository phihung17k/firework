import 'dart:math';
import 'package:firework/models/chain_bullet_v2.dart';
import 'package:flutter/material.dart';
import '../painters/chain_bullet_v2_painter.dart';
import '../provider/stream_provider.dart';

class ExplosionV2Animation extends StatelessWidget {
  final int index;
  final AnimationController fireworkController;
  final ChainBulletV2 chainBullet;
  final double startToExplosionTime;
  final double explodeToScaleBulletTime;
  final Animation<double> scaleAnimation;
  final double scaleSpace;
  final List<Color> colors;

  const ExplosionV2Animation({
    super.key,
    required this.index,
    required this.fireworkController,
    required this.chainBullet,
    required this.startToExplosionTime,
    required this.explodeToScaleBulletTime,
    required this.scaleAnimation,
    required this.scaleSpace,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: ValueKey("repaint $index"),
      child: Transform.rotate(
        angle: pi / 4,
        child: AnimatedBuilder(
          animation: fireworkController,
          builder: (context, _) {
            Animation<double> bezierAnimation =
                Tween<double>(begin: 0, end: 1.00).animate(CurvedAnimation(
                    parent: fireworkController,
                    curve: Interval(
                        startToExplosionTime, explodeToScaleBulletTime,
                        curve: Curves.easeOutSine)));
            // scale bullet
            if (scaleAnimation.value < 1) {
              chainBullet.radiusOfBullet =
                  chainBullet.radiusOfBullet! * scaleAnimation.value;
            }
            return StreamBuilder<bool>(
                stream: StreamProvider.of<Stream<bool>>(context),
                builder: (context, snapshot) {
                  return CustomPaint(
                    key: ValueKey("explosionBulletAnimation $index"),
                    painter: ChainBulletV2Painter(
                      p1Translate: chainBullet.p1!,
                      p2Translate: chainBullet.p2!,
                      p3Translate: chainBullet.p3!,
                      totalPoint: 10,
                      isDeleted: snapshot.data ?? false,
                      radiusOfBullet: chainBullet.radiusOfBullet!,
                      bezierAnimation: bezierAnimation,
                      scaleSpace: scaleSpace,
                      colors: colors,
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
