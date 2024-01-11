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
  StreamController<ScreenState> controller1 = StreamController();
  StreamController<ScreenState> controller2 = StreamController();
  StreamController<ScreenState> controller3 = StreamController();
  StreamController<ScreenState> controller4 = StreamController();
  Stream<Firework> get fire1Stream =>
      controller1.stream.map((state) => state.fire!);
  Stream<Firework> get fire2Stream =>
      controller2.stream.map((state) => state.fire!);
  Stream<Firework> get fire3Stream =>
      controller3.stream.map((state) => state.fire!);
  Stream<Firework> get fire4Stream =>
      controller4.stream.map((state) => state.fire!);

  List<Stream<Firework>> streamList = [];
  StreamController<bool> volumeController = StreamController();
  bool muteVolume = false;

  @override
  void initState() {
    super.initState();
    streamList = [fire1Stream, fire2Stream, fire3Stream, fire4Stream];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  void init() {
    double spaceWidth = MediaQuery.sizeOf(context).width - 150;
    double spaceHeight = MediaQuery.sizeOf(context).height - 150;
    var durationForAFirework = const Duration(seconds: 5);
    var durationContinousFire1 = const Duration(seconds: 5);
    var durationContinousFire2 = const Duration(seconds: 6);
    var durationContinousFire3 = const Duration(seconds: 7);
    var durationContinousFire4 = const Duration(seconds: 8);

    controller1.add(ScreenState(
        fire: Firework(
      key: "version 1 first time",
      distance: RandomUtil.ran(200, spaceHeight),
      positionFromLeft: RandomUtil.ran(150, spaceWidth),
      scaleSpace: 0.7,
      duration: durationForAFirework,
      explosionTime: 0.3,
      fadeAwayTime: 0.5,
      explosionEffectRadius: 20,
      colors: [getRandomColor(), getRandomColor()],
    )));
    controller2.add(ScreenState(
        fire: Firework(
      key: "version 2 first time",
      distance: RandomUtil.ran(200, spaceHeight),
      positionFromLeft: RandomUtil.ran(150, spaceWidth),
      scaleSpace: 0.7,
      duration: durationForAFirework,
      explosionTime: 0.3,
      fadeAwayTime: 0.5,
      explosionEffectRadius: 20,
      colors: [getRandomColor(), getRandomColor()],
    )));

    // first time
    repeat(controller1, durationContinousFire1, durationForAFirework,
        spaceWidth, spaceHeight, true);
    repeat(controller2, durationContinousFire2, durationForAFirework,
        spaceWidth, spaceHeight, true);
    repeat(controller3, durationContinousFire3, durationForAFirework,
        spaceWidth, spaceHeight, false);
    repeat(controller4, durationContinousFire4, durationForAFirework,
        spaceWidth, spaceHeight, false);
  }

  void repeat(
      StreamController controller,
      Duration durationContinousFire,
      Duration durationForAFirework,
      double spaceWidth,
      double spaceHeight,
      bool useColors) {
    Color color = getRandomColor();
    Timer.periodic(
      durationContinousFire,
      (timer) {
        controller.add(ScreenState(
            fire: Firework(
          key: "${timer.tick}",
          distance: RandomUtil.ran(200, spaceHeight),
          positionFromLeft: RandomUtil.ran(150, spaceWidth),
          scaleSpace: 0.7,
          duration: durationForAFirework,
          explosionTime: 0.3,
          fadeAwayTime: 0.5,
          explosionEffectRadius: 20,
          colors: useColors ? [color, getRandomColor()] : [color, color],
          mute: muteVolume,
        )));
      },
    );
  }

  Color getRandomColor() {
    return Color(
        Colors.primaries[RandomUtil.ranInt(0, Colors.primaries.length)].value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 33, 58),
      body: Stack(
        children: [
          Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                  onPressed: () {
                    muteVolume = !muteVolume;
                    volumeController.add(muteVolume);
                  },
                  icon: StreamBuilder<bool>(
                      stream: volumeController.stream,
                      builder: (context, snapshot) {
                        return Icon(
                          (snapshot.hasData && snapshot.data!)
                              ? Icons.volume_up
                              : Icons.volume_off,
                          color: Colors.grey,
                        );
                      }))),
          for (int i = 0; i < 4; i++)
            StreamBuilder(
              stream: streamList[i],
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Firework fire = snapshot.data!;
                  return RepaintBoundary(
                      key: ValueKey("repaint boundary $i ${fire.key}"),
                      child: FireworkWidget(
                        key: ValueKey(fire.key),
                        version: i % 2 == 0 ? 1 : 2,
                        distance: fire.distance!,
                        positionFromLeft: fire.positionFromLeft!,
                        scaleSpace: fire.scaleSpace!,
                        fireworkDuration: fire.duration!,
                        explosionTime: fire.explosionTime!,
                        fadeAwayTime: fire.fadeAwayTime!,
                        explosionEffectRadius: fire.explosionEffectRadius!,
                        colors: fire.colors!,
                        muteVolume: fire.mute!,
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
    controller1.close();
    controller2.close();
    controller3.close();
    controller4.close();
    super.dispose();
  }
}
