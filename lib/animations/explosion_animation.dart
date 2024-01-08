import 'package:flutter/material.dart';
import '../models/chain_bullet.dart';
import '../painters/chain_bullet_painter.dart';
import '../provider/stream_provider.dart';

class ExplosionAnimation extends StatelessWidget {
  final int index;
  final AnimationController fireworkController;
  final ChainBullet chainBullet;
  final double startToExplosionTime;
  final double explodeToScaleBulletTime;
  final Animation<double> scaleAnimation;
  final double scaleSpace;
  final List<Color> colors;

  const ExplosionAnimation({
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
      child: AnimatedBuilder(
        animation: fireworkController,
        builder: (context, _) {
          Animation<double> explosionBulletAnimation =
              Tween<double>(begin: 0, end: chainBullet.totalDistance).animate(
                  CurvedAnimation(
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
                  painter: ChainBulletPainter(
                    totalDistance: chainBullet.totalDistance!,
                    currentDistance: explosionBulletAnimation.value,
                    angle: chainBullet.angle!,
                    isDeleted: snapshot.data ?? false,
                    radiusOfBullet: chainBullet.radiusOfBullet!,
                    totalPoint: 10,
                    scaleSpace: scaleSpace,
                    colors: colors,
                  ),
                );
              });
        },
      ),
    );
  }
}
