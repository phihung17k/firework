import 'package:firework/painters/chain_bullet_prototype_painter.dart';
import 'package:flutter/material.dart';

class ChainBulletWidget extends StatefulWidget {
  const ChainBulletWidget({super.key});

  @override
  State<ChainBulletWidget> createState() => _ChainBulletWidgetState();
}

class _ChainBulletWidgetState extends State<ChainBulletWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    animation = Tween<double>(begin: 0, end: 360).animate(controller);

    controller.repeat();
    // controller.addStatusListener((status) {
    //   if (controller.isCompleted) {
    //     controller.reverse();
    //   } else if (controller.isDismissed) {
    //     controller.forward();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Center(
          child: RepaintBoundary(
            child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return CustomPaint(
                    key: const ValueKey("CustomePaint4"),
                    painter: ChainBulletPrototypePainter(
                      roY: animation.value,
                    ),
                    // size: Size.square(100),
                  );
                }),
          ),
        ),
      ],
    ));
  }
}
