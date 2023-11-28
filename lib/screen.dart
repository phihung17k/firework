import 'package:firework/firework_widget.dart';
import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 33, 58),
      body: Stack(
        children: [
          FireworkWidget(
            distance: 500,
            positionFromLeft: 400,
            scaleSpace: 0.7,
            fireworkDuration: Duration(seconds: 5),
            explosionTime: 0.3,
            fadeAwayTime: 0.5,
            explosionEffectRadius: 20,
          ),
        ],
      ),
    );
  }
}
