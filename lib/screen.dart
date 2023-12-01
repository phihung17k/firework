import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:firework/firework_widget.dart';
import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class ScreenState extends Equatable {
  final FireworkWidget? fire1;
  final FireworkWidget? fire2;
  final FireworkWidget? fire3;

  const ScreenState({this.fire1, this.fire2, this.fire3});

  ScreenState copyWith(
      {FireworkWidget? fire1, FireworkWidget? fire2, FireworkWidget? fire3}) {
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
  Stream<FireworkWidget> get fire1Stream =>
      controller.stream.map((state) => state.fire1!);
  Stream<FireworkWidget> get fire2Stream =>
      controller.stream.map((state) => state.fire2!);
  Stream<FireworkWidget> get fire3Stream =>
      controller.stream.map((state) => state.fire3!);

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
    var duration1 = const Duration(seconds: 5);
    var duration2 = const Duration(seconds: 6);
    var duration3 = const Duration(seconds: 7);

    Timer.periodic(
      duration1,
      (timer) {
        controller.add(ScreenState(
            fire1: FireworkWidget(
          key: ValueKey("firework1 $timer"),
          distance: 500,
          positionFromLeft: Random().nextDouble() * (width - 400) + 100,
          scaleSpace: 0.7,
          fireworkDuration: duration1,
          explosionTime: 0.3,
          fadeAwayTime: 0.5,
          explosionEffectRadius: 20,
        )));
      },
    );

    Timer.periodic(
      duration2,
      (timer) {
        controller.add(ScreenState(
            fire2: FireworkWidget(
          key: ValueKey("firework2 $timer"),
          distance: 600,
          positionFromLeft: Random().nextDouble() * (width - 400) + 100,
          scaleSpace: 0.7,
          fireworkDuration: duration1,
          explosionTime: 0.3,
          fadeAwayTime: 0.5,
          explosionEffectRadius: 20,
        )));
      },
    );
    Timer.periodic(
      duration3,
      (timer) {
        controller.add(ScreenState(
            fire3: FireworkWidget(
          key: ValueKey("firework3 $timer"),
          distance: 650,
          positionFromLeft: Random().nextDouble() * (width - 400) + 100,
          scaleSpace: 0.7,
          fireworkDuration: duration1,
          explosionTime: 0.3,
          fadeAwayTime: 0.5,
          explosionEffectRadius: 20,
        )));
      },
    );
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

          StreamBuilder(
            stream: fire1Stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return RepaintBoundary(
                    key: ValueKey(snapshot.data), child: snapshot.data!);
              }
              return const SizedBox();
            },
          ),
          StreamBuilder(
            stream: fire2Stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return RepaintBoundary(
                    key: ValueKey(snapshot.data), child: snapshot.data!);
              }
              return const SizedBox();
            },
          ),
          StreamBuilder(
            stream: fire3Stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return RepaintBoundary(
                    key: ValueKey(snapshot.data), child: snapshot.data!);
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
    super.dispose();
  }
}
