import 'dart:async';

import 'package:firework/models/chain_bullet.dart';
import 'package:flutter/material.dart';
import 'painters/chain_bullet_v2_painter.dart';
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
  // late Animation<double> fadeAnimation;
  // late Animation<double> scaleAnimation;

  // late Animation<double> transformAnimation;
  late Animation<double> bezierAnimation;

  bool isDeletedBullet = false;
  List<ChainBullet> chainBullets =
      List.generate(150, (index) => ChainBullet.index(index: index));
  double fadedTimer = 0.6;

  @override
  void initState() {
    super.initState();

    translateController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000));
    // scaleAnimation =
    //     Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
    //   parent: translateController,
    //   curve: Interval(fadedTimer, 1, curve: Curves.elasticInOut),
    // ));
    // transformAnimation = Tween<double>(begin: 0, end: 360).animate(
    //     CurvedAnimation(
    //         parent: translateController,
    //         curve: const Interval(0, 1, curve: Curves.linear)));

    // explosionScaleAnimation = Tween<double>(begin: 0, end: 50).animate(
    //     CurvedAnimation(
    //         parent: translateController,
    //         curve: const Interval(0, 0.3, curve: Curves.easeOutBack)));

    bezierAnimation = Tween<double>(begin: 0, end: 1.00).animate(
        CurvedAnimation(parent: translateController, curve: Curves.linear));

    translateController.forward();
    // translateController.addStatusListener((status) {
    //   if (translateController.isCompleted) {
    //     Future.delayed(
    //       const Duration(milliseconds: 1000),
    //       () {
    //         setState(() {
    //           // isDeletedRocket = true;
    //         });
    //       },
    //     );
    //   }
    // });
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
            painter: CirclePainter(radius: 200),
            size: Size.infinite,
          ),
          // version 2
          Center(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: translateController,
                builder: (context, _) {
                  // var chainBullet = chainBullets[i];
                  var chainBullet = ChainBullet(
                      totalDistance: 200, angle: 30, radiusOfBullet: 8);
                  translateAnimation =
                      Tween<double>(begin: 0, end: chainBullet.totalDistance)
                          .animate(CurvedAnimation(
                              parent: translateController,
                              curve: Interval(0, fadedTimer,
                                  curve: Curves.easeOutSine)));
                  // scale bullet
                  // if (scaleAnimation.value < 1) {
                  //   chainBullet.radiusOfBullet =
                  //       chainBullet.radiusOfBullet! * scaleAnimation.value;
                  // }
                  return CustomPaint(
                    painter: ChainBulletV2Painter(
                      totalDistance: chainBullet.totalDistance!,
                      currentDistance: translateAnimation.value,
                      angle: chainBullet.angle!,
                      isDeleted: isDeletedBullet,
                      radiusOfBullet: chainBullet.radiusOfBullet!,
                      totalPoint: 10,
                      bezierAnimation: bezierAnimation,
                    ),
                  );
                },
              ),
            ),
          ),

          // version 1
          // for (int i = 0; i < chainBullets.length; i++)
          //   Center(
          //     child: RepaintBoundary(
          //       key: ValueKey("repaint $i"),
          //       child: AnimatedBuilder(
          //         animation: translateController,
          //         builder: (context, _) {
          //           var chainBullet = chainBullets[i];
          //           translateAnimation =
          //               Tween<double>(begin: 0, end: chainBullet.totalDistance)
          //                   .animate(CurvedAnimation(
          //                       parent: translateController,
          //                       curve: Interval(0, fadedTimer,
          //                           curve: Curves.easeOutSine)));
          //           // scale bullet
          //           // if (scaleAnimation.value < 1) {
          //           //   chainBullet.radiusOfBullet =
          //           //       chainBullet.radiusOfBullet! * scaleAnimation.value;
          //           // }
          //           return CustomPaint(
          //             key: ValueKey("translateAnimation $i"),
          //             painter: ChainBulletPainter(
          //               totalDistance: chainBullet.totalDistance!,
          //               currentDistance: translateAnimation.value,
          //               angle: chainBullet.angle!,
          //               isDeleted: isDeletedRocket,
          //               radiusOfBullet: chainBullet.radiusOfBullet!,
          //               totalPoint: 10,
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
