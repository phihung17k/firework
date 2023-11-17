import 'package:flutter/material.dart';
import 'painters/rocket_painter.dart';

class RocketWidget extends StatefulWidget {
  const RocketWidget({super.key});

  @override
  State<RocketWidget> createState() => _RocketWidgetState();
}

class _RocketWidgetState extends State<RocketWidget>
    with SingleTickerProviderStateMixin<RocketWidget> {
  late AnimationController controller;
  late Animation<double> translateAnimation;

  double height = 800;
  Duration duration = const Duration(milliseconds: 2500);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: duration);
    // translateAnimation = Tween<double>(begin: 0, end: radius)
    //     .animate(CurvedAnimation(parent: controller, curve: Curves.easeInCirc));
    translateAnimation = Tween<double>(begin: 0, end: height).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));

    controller.forward();
    // // controller.addStatusListener((status) {
    // //   if (controller.isCompleted) {
    // //     controller.reverse();
    // //   } else if (controller.isDismissed) {
    // //     controller.forward();
    // //   }
    // // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: translateAnimation,
              builder: (context, _) {
                return CustomPaint(
                  key: const ValueKey("CustomePaint1"),
                  painter:
                      RocketPainter(currentDistance: translateAnimation.value),
                  // size: Size.infinite,
                );
              },
            ),
          ),
        ),
      ],
    ));
  }
}
