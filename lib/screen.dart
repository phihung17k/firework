import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firework/firework_widget.dart';
import 'package:firework/models/firework.dart';
import 'package:firework/utils/random_util.dart';
import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class ScreenState extends Equatable {
  final Firework? fire;

  const ScreenState({this.fire});

  ScreenState copyWith({Firework? fire}) {
    return ScreenState(
      fire: fire ?? this.fire,
    );
  }

  @override
  List<Object?> get props => [fire];
}

class _ScreenState extends State<Screen> {
  List<int> numberOfFirework = List.generate(50, (index) => index);

  StreamController<ScreenState> controller = StreamController.broadcast();
  StreamController<ScreenState> controller2 = StreamController.broadcast();
  Stream<Firework> get fire1Stream =>
      controller.stream.map((state) => state.fire!);
  Stream<Firework> get fire2Stream =>
      controller2.stream.map((state) => state.fire!);

  late Timer timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  void init() {
    double spaceWidth = MediaQuery.sizeOf(context).width - 200;
    double spaceHeight = MediaQuery.sizeOf(context).height - 200;
    var duration = const Duration(seconds: 5);
    var duration1 = const Duration(seconds: 5);
    var duration2 = const Duration(seconds: 7);

    // first time
    Timer.periodic(
      duration1,
      (timer) {
        // debugPrint("add fire1 ${timer.tick}");
        controller.add(ScreenState(
            fire: Firework(
          key: "firework1 ${timer.tick}",
          distance: RandomUtil.ran(200, spaceHeight),
          positionFromLeft: RandomUtil.ran(200, spaceWidth),
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
        // debugPrint("add fire2 ${timer.tick}");
        controller2.add(ScreenState(
            fire: Firework(
          key: "firework2 ${timer.tick}",
          distance: RandomUtil.ran(200, spaceHeight),
          positionFromLeft: RandomUtil.ran(200, spaceWidth),
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
    // double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 33, 58),
      body: Stack(
        children: [
          StreamBuilder(
            stream: fire1Stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Firework fire = snapshot.data!;
                return RepaintBoundary(
                    key: ValueKey("repaint boundary 1 ${fire.key}"),
                    child: FireworkWidget(
                      key: ValueKey(fire.key),
                      version: 1,
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
            stream: fire2Stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Firework fire = snapshot.data!;
                return RepaintBoundary(
                    key: ValueKey("repaint boundary 2 ${fire.key}"),
                    child: FireworkWidget(
                      key: ValueKey(fire.key),
                      version: 2,
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.close();
    controller2.close();
    super.dispose();
  }
}
