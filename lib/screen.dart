import 'dart:async';
import 'dart:math';

import 'package:firework/firework_widget.dart';
import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  List<int> numberOfFirework = List.generate(50, (index) => index);

  StreamController controller1 = StreamController.broadcast();
  // Stream<FireworkWidget> get fireworkStream1 =>
  //     controller1.stream.map((event) => event);

  StreamController controller2 = StreamController.broadcast();
  // Stream<FireworkWidget> get fireworkStream2 =>
  //     controller2.stream.map((event) => event);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  void init() async {
    double width = MediaQuery.sizeOf(context).width;
    var duration1 = const Duration(seconds: 6);
    var duration2 = const Duration(seconds: 5);

    // for (var i = 0; i < numberOfFirework.length; i++) {
    //   _addDelayedFirework(i, duration1, width);
    // }
    // print("1");
    // await _addDelayedFirework(1, const Duration(seconds: 1), width);
    // print("3");
    // await _addDelayedFirework(2, const Duration(seconds: 3), width);
    // print("5");
    // await _addDelayedFirework(3, const Duration(seconds: 2), width);
    // print("end");
    Stream.periodic(duration1).listen((event) {
      controller1.add(FireworkWidget(
        key: ValueKey("firework1 $event"),
        distance: 500,
        positionFromLeft: Random().nextDouble() * (width - 400) + 100,
        scaleSpace: 0.7,
        fireworkDuration: duration1,
        explosionTime: 0.3,
        fadeAwayTime: 0.5,
        explosionEffectRadius: 20,
      ));
    });

    Stream.periodic(duration2).listen((event) {
      controller2.add(FireworkWidget(
        key: ValueKey("firework2 $event"),
        distance: 500,
        positionFromLeft: Random().nextDouble() * (width - 400) + 100,
        scaleSpace: 0.7,
        fireworkDuration: duration1,
        explosionTime: 0.3,
        fadeAwayTime: 0.5,
        explosionEffectRadius: 20,
      ));
    });

    // Future.forEach(numberOfFirework, (element) async {
    // await Future.delayed(
    //   duration1,
    //   () {
    //     print("add 1 $element");
    //   },
    // );
    // controller1.add(FireworkWidget(
    //   key: ValueKey("firework1 $element"),
    //   distance: 500,
    //   positionFromLeft: Random().nextDouble() * (width - 400) + 200,
    //   scaleSpace: 0.7,
    //   fireworkDuration: duration1,
    //   explosionTime: 0.3,
    //   fadeAwayTime: 0.5,
    //   explosionEffectRadius: 20,
    // ));
    // });
    // Future.forEach(numberOfFirework, (element) async {
    //   await Future.delayed(
    //     duration2,
    //     () {
    //       print("add 2 $element");
    //     },
    //   );
    //   controller2.add(FireworkWidget(
    //     key: ValueKey("firework2 $element"),
    //     distance: 500,
    //     positionFromLeft: Random().nextDouble() * (width - 400) + 200,
    //     scaleSpace: 0.7,
    //     fireworkDuration: duration2,
    //     explosionTime: 0.3,
    //     fadeAwayTime: 0.5,
    //     explosionEffectRadius: 20,
    //   ));
    // });
  }

  Future<void> _addDelayedFirework(
      int element, Duration delay, double width) async {
    print("Future.delayed $element");
    await Future.delayed(delay);
    print("controller1.add $element");
    controller1.add(FireworkWidget(
      key: ValueKey("firework1 $element"),
      distance: 500,
      positionFromLeft: Random().nextDouble() * (width - 400) + 200,
      scaleSpace: 0.7,
      fireworkDuration: const Duration(seconds: 5),
      explosionTime: 0.3,
      fadeAwayTime: 0.5,
      explosionEffectRadius: 20,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 33, 58),
      body: Stack(
        children: [
          // FireworkWidget(
          //   distance: 500,
          //   positionFromLeft: 400,
          //   scaleSpace: 0.7,
          //   fireworkDuration: Duration(seconds: 5),
          //   explosionTime: 0.3,
          //   fadeAwayTime: 0.5,
          //   explosionEffectRadius: 20,
          // ),

          SizedBox.expand(
            child: StreamBuilder(
              stream: controller1.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return RepaintBoundary(
                      key: ValueKey(snapshot.data), child: snapshot.data!);
                }
                return const SizedBox();
              },
            ),
          ),
          SizedBox.expand(
            child: StreamBuilder(
              stream: controller2.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return RepaintBoundary(
                      key: ValueKey(snapshot.data), child: snapshot.data!);
                }
                return const SizedBox();
              },
            ),
          )
        ],
      ),
    );
  }
}
