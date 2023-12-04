import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:firework/firework_widget.dart';
import 'package:firework/models/firework.dart';
import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class ScreenState extends Equatable {
  final Firework? fire1;
  final Firework? fire2;
  final Firework? fire3;

  const ScreenState({this.fire1, this.fire2, this.fire3});

  ScreenState copyWith({Firework? fire1, Firework? fire2, Firework? fire3}) {
    return ScreenState(
      fire1: fire1 ?? this.fire1,
      fire2: fire2 ?? this.fire2,
      fire3: fire3 ?? this.fire3,
    );
  }

  @override
  List<Object?> get props => [fire1, fire2, fire3];
}

class _ScreenState extends State<Screen> {
  List<int> numberOfFirework = List.generate(50, (index) => index);

  StreamController<ScreenState> controller = StreamController.broadcast();
  StreamController<ScreenState> controller2 = StreamController.broadcast();
  Stream<Firework> get fire1_1Stream =>
      controller.stream.map((state) => state.fire1!);
  Stream<Firework> get fire1_2Stream =>
      controller.stream.map((state) => state.fire2!);
  Stream<Firework> get fire2_1Stream =>
      controller2.stream.map((state) => state.fire1!);
  Stream<Firework> get fire2_2Stream =>
      controller2.stream.map((state) => state.fire2!);

  // Sink<FireworkWidget> get fire1Sink => controller

  late Timer timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  void init() {
    double width = MediaQuery.sizeOf(context).width;
    var duration = const Duration(seconds: 5);
    var duration1 = const Duration(seconds: 5);
    var duration2 = const Duration(seconds: 5);

    Timer.periodic(
      duration1,
      (timer) {
        debugPrint("add fire1 ${timer.tick}");
        controller.add(ScreenState(
            fire1: Firework(
          key: "firework1 ${timer.tick}",
          distance: 500,
          positionFromLeft: Random().nextDouble() * (width - 400) + 100,
          scaleSpace: 0.7,
          duration: duration,
          explosionTime: 0.3,
          fadeAwayTime: 0.5,
          explosionEffectRadius: 20,
        )));
      },
    );

    Timer.periodic(
      duration2,
      (timer) {
        debugPrint("add fire2 ${timer.tick}");
        controller.add(ScreenState(
            fire2: Firework(
          key: "firework2 ${timer.tick}",
          distance: 600,
          positionFromLeft: Random().nextDouble() * (width - 400) + 100,
          scaleSpace: 0.7,
          duration: duration,
          explosionTime: 0.3,
          fadeAwayTime: 0.5,
          explosionEffectRadius: 20,
        )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
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

          StreamBuilder(
            stream: fire1_1Stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Firework fire = snapshot.data!;
                return RepaintBoundary(
                    key: ValueKey("repaint boundary 1 ${fire.key}"),
                    child: FireworkWidget(
                      key: ValueKey(fire.key),
                      distance: fire.distance!,
                      positionFromLeft: fire.positionFromLeft!,
                      scaleSpace: fire.scaleSpace!,
                      fireworkDuration: fire.duration!,
                      explosionTime: fire.explosionTime!,
                      fadeAwayTime: fire.fadeAwayTime!,
                      explosionEffectRadius: fire.explosionEffectRadius!,
                    ));
              }
              return const SizedBox();
            },
          ),
          StreamBuilder(
            stream: fire1_2Stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Firework fire = snapshot.data!;
                return RepaintBoundary(
                    key: ValueKey("repaint boundary 2 ${fire.key}"),
                    child: FireworkWidget(
                      key: ValueKey(fire.key),
                      distance: fire.distance!,
                      positionFromLeft: fire.positionFromLeft!,
                      scaleSpace: fire.scaleSpace!,
                      fireworkDuration: fire.duration!,
                      explosionTime: fire.explosionTime!,
                      fadeAwayTime: fire.fadeAwayTime!,
                      explosionEffectRadius: fire.explosionEffectRadius!,
                    ));
              }
              return const SizedBox();
            },
          ),
          // StreamBuilder(
          //   stream: fire3Stream,
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return RepaintBoundary(
          //           key: ValueKey(snapshot.data), child: snapshot.data!);
          //     }
          //     return const SizedBox();
          //   },
          // ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }
}
