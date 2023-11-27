import 'package:firework/models/chain_bullet.dart';
import 'package:firework/painters/chain_bullet_painter.dart';
import 'package:firework/painters/rocket_painter.dart';
import 'package:flutter/material.dart';

import 'painters/explosion_painter.dart';

class FireworkPage extends StatefulWidget {
  const FireworkPage({super.key});

  @override
  State<FireworkPage> createState() => _FireworkPageState();
}

class _FireworkPageState extends State<FireworkPage>
    with TickerProviderStateMixin<FireworkPage> {
  late AnimationController controller;
  late Animation<double> rocketAnimation;
  late AnimationController explosionController;
  late Animation<double> explosionEffectAnimation;
  late Animation<double> explosionBulletAnimation;

  late Animation<double> scaleAnimation;

  double height = 700;
  Duration fireworkDuration = const Duration(milliseconds: 5000);

  bool isDeletedRocket = false;
  bool isDeletedBullet = false;
  List<ChainBullet> chainBullets =
      List.generate(150, (index) => ChainBullet(index: index));
  double startToExplosionTime = 0.2;
  double explodeToScaleBulletTime = 0.4;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: fireworkDuration);
    explosionController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    rocketAnimation = Tween<double>(begin: 0, end: height).animate(
        CurvedAnimation(
            parent: controller,
            curve:
                Interval(0, startToExplosionTime, curve: Curves.easeOutCubic)));
    scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(explodeToScaleBulletTime, 1, curve: Curves.elasticInOut),
    ));

    controller.forward();
    controller.addStatusListener((status) {
      if (controller.isCompleted) {
        setState(() {
          isDeletedBullet = true;
        });
      }
    });

    // explosion
    explosionEffectAnimation = Tween<double>(begin: 0, end: 30).animate(
        CurvedAnimation(
            parent: explosionController, curve: Curves.easeOutQuart));

    Future.delayed(
      Duration(
          milliseconds: (fireworkDuration.inMilliseconds *
              (startToExplosionTime)) as int),
      () {
        explosionController.forward();
      },
    );

    explosionController.addStatusListener((status) {
      if (explosionController.isCompleted) {
        explosionController.reverse();
        setState(() {
          isDeletedRocket = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 17, 33, 58),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: RepaintBoundary(
                key: const ValueKey("repaint rocketAnimation"),
                child: AnimatedBuilder(
                  animation: rocketAnimation,
                  builder: (context, _) {
                    return CustomPaint(
                      key: const ValueKey("rocketAnimation"),
                      painter: RocketPainter(
                          totalDistance: height,
                          currentDistance: rocketAnimation.value,
                          isDeleted: isDeletedRocket),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: height,
              left: MediaQuery.sizeOf(context).width / 2,
              child: RepaintBoundary(
                key: const ValueKey("repaint explosionEffectAnimation"),
                child: AnimatedBuilder(
                  animation: explosionEffectAnimation,
                  builder: (context, _) {
                    return CustomPaint(
                      key: const ValueKey("explosionEffectAnimation"),
                      painter: ExplosionPainter(
                          radius: explosionEffectAnimation.value),
                    );
                  },
                ),
              ),
            ),
            for (int i = 0; i < chainBullets.length; i++)
              Positioned(
                bottom: height,
                left: MediaQuery.sizeOf(context).width / 2,
                child: RepaintBoundary(
                  key: ValueKey("repaint $i"),
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) {
                      var chainBullet = chainBullets[i];
                      explosionBulletAnimation = Tween<double>(
                              begin: 0, end: chainBullet.totalDistance)
                          .animate(CurvedAnimation(
                              parent: controller,
                              curve: Interval(startToExplosionTime,
                                  explodeToScaleBulletTime,
                                  curve: Curves.easeOutSine)));
                      // scale bullet
                      if (scaleAnimation.value < 1) {
                        chainBullet.radiusOfBullet =
                            chainBullet.radiusOfBullet! * scaleAnimation.value;
                      }
                      return CustomPaint(
                        key: ValueKey("explosionBulletAnimation $i"),
                        painter: ChainBulletPainter(
                          totalDistance: chainBullet.totalDistance!,
                          currentDistance: explosionBulletAnimation.value,
                          angle: chainBullet.angle!,
                          isDeleted: isDeletedBullet,
                          radiusOfBullet: chainBullet.radiusOfBullet!,
                          totalPoint: 10,
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ));
  }
}
