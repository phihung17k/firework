import 'package:flutter/material.dart';
import '../painters/rocket_painter.dart';
import '../provider/stream_provider.dart';

class RocketAnimation extends StatelessWidget {
  const RocketAnimation({
    super.key,
    required this.rocketAnimation,
    required this.distance,
    required this.colors,
  });

  final Animation<double> rocketAnimation;
  final double distance;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: const ValueKey("repaint rocketAnimation"),
      child: AnimatedBuilder(
        animation: rocketAnimation,
        builder: (context, _) {
          return StreamBuilder<bool>(
              stream: StreamProvider.of<Stream<bool>>(context),
              builder: (context, snapshot) {
                return CustomPaint(
                  key: const ValueKey("rocketAnimation"),
                  painter: RocketPainter(
                    totalDistance: distance,
                    currentDistance: rocketAnimation.value,
                    isDeleted: snapshot.data ?? false,
                    colors: colors,
                  ),
                );
              });
        },
      ),
    );
  }
}
