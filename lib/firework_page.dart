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
  late Animation<double> explosionAnimation;

  double height = 800;
  Duration duration = const Duration(milliseconds: 3000);

  bool isDeletedRocket = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    explosionController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    rocketAnimation = Tween<double>(begin: 0, end: height).animate(
        CurvedAnimation(
            parent: controller,
            curve: const Interval(0, 1, curve: Curves.easeOutCubic)));
    explosionAnimation = Tween<double>(begin: 0, end: 30).animate(
        CurvedAnimation(
            parent: explosionController,
            curve: const Interval(0, 1, curve: Curves.easeOutQuart)));

    controller.forward();
    controller.addStatusListener((status) {
      if (controller.isCompleted) {
        explosionController.forward();
      }
    });

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
                key: const ValueKey("repaint1"),
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
              bottom: 800,
              left: MediaQuery.sizeOf(context).width / 2,
              child: RepaintBoundary(
                key: const ValueKey("repaint2"),
                child: AnimatedBuilder(
                  animation: explosionAnimation,
                  builder: (context, _) {
                    return CustomPaint(
                      key: const ValueKey("explosionAnimation"),
                      painter:
                          ExplosionPainter(radius: explosionAnimation.value),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
