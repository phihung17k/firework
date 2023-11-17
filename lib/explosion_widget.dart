import 'package:firework/painters/explosion_painter.dart';
import 'package:flutter/material.dart';
import 'painters/bullet_painter.dart';
import 'painters/circle_painter.dart';

class ExplosionWidget extends StatefulWidget {
  const ExplosionWidget({super.key});

  @override
  State<ExplosionWidget> createState() => _ExplosionWidgetState();
}

class _ExplosionWidgetState extends State<ExplosionWidget>
    with TickerProviderStateMixin<ExplosionWidget> {
  late AnimationController translateController;
  late Animation<double> translateAnimation;

  // late AnimationController explosionController;
  late Animation<double> explosionScaleAnimation;

  double radius = 200;

  @override
  void initState() {
    super.initState();

    translateController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    translateAnimation = Tween<double>(begin: 0, end: radius).animate(
        CurvedAnimation(
            parent: translateController,
            curve: const Interval(0, 1, curve: Curves.decelerate)));

    // explosionController =
    //     AnimationController(vsync: this, duration: const Duration(seconds: 2));
    explosionScaleAnimation = Tween<double>(begin: 0, end: 50).animate(
        CurvedAnimation(
            parent: translateController,
            curve: const Interval(0, 0.3, curve: Curves.easeOutBack)));

    translateController.forward();
    translateController.addStatusListener((status) {
      if (translateController.isCompleted) {
        translateController.reverse();
      } else if (translateController.isDismissed) {
        translateController.forward();
      }
    });
  }

  @override
  void dispose() {
    translateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 33, 58),
      body: Stack(
        children: [
          CustomPaint(
            painter: CirclePainter(radius: radius),
            size: Size.infinite,
          ),
          Center(
            child: RepaintBoundary(
              key: const ValueKey("repaint2"),
              child: AnimatedBuilder(
                animation: explosionScaleAnimation,
                builder: (context, _) {
                  return CustomPaint(
                    key: const ValueKey("explosionScaleAnimation"),
                    painter:
                        ExplosionPainter(radius: explosionScaleAnimation.value),
                  );
                },
              ),
            ),
          ),
          Center(
            child: RepaintBoundary(
              key: const ValueKey("repaint1"),
              child: AnimatedBuilder(
                animation: translateAnimation,
                builder: (context, _) {
                  return CustomPaint(
                    key: const ValueKey("translateAnimation"),
                    painter: BulletPainter(increment: translateAnimation.value),
                  );
                },
              ),
            ),
          ),

          // the second way to paint bullets
          // Center(
          //   child: RepaintBoundary(
          //     child: AnimatedBuilder(
          //       animation: translateAnimation,
          //       child: CustomPaint(
          //         key: const ValueKey("CustomePaint2"),
          //         painter: FireworkPainter(radius: radius),
          //         // size: Size.infinite,
          //       ),
          //       builder: (context, child) {
          //         return Transform.translate(
          //           offset: Offset(translateAnimation.value * cos(pi / 3),
          //               -translateAnimation.value * sin(pi / 3)),
          //           child: child,
          //         );
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
