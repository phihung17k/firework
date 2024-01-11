import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:firework/animations/explosion_animation.dart';
import 'package:firework/models/chain_bullet.dart';
import 'package:firework/models/chain_bullet_v2.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'animations/explosion_effect_animation.dart';
import 'animations/explosion_v2_animation.dart';
import 'animations/rocket_animation.dart';
import 'provider/stream_provider.dart';

class FireworkWidget extends StatefulWidget {
  final int version;
  final double distance;
  final double positionFromLeft;
  final double scaleSpace;
  final Duration fireworkDuration;
  final double explosionTime;
  final double fadeAwayTime;
  final double explosionEffectRadius;
  final List<Color> colors;
  final bool muteVolume;

  const FireworkWidget({
    super.key,
    this.version = 1,
    this.distance = 700,
    this.positionFromLeft = 150,
    this.scaleSpace = 1,
    this.fireworkDuration = const Duration(milliseconds: 5000),
    this.explosionTime = 0.2,
    this.fadeAwayTime = 0.4,
    this.explosionEffectRadius = 30,
    this.colors = const [Colors.red, Colors.white],
    this.muteVolume = false,
  });

  @override
  State<FireworkWidget> createState() => _FireworkWidgetState();
}

class FireworkState extends Equatable {
  final bool isDeletedRocket;
  final bool isDeletedBullet;

  const FireworkState(
      {this.isDeletedRocket = false, this.isDeletedBullet = false});

  FireworkState copyWith({bool? isDeletedRocket, bool? isDeletedBullet}) {
    return FireworkState(
      isDeletedBullet: isDeletedBullet ?? this.isDeletedBullet,
      isDeletedRocket: isDeletedRocket ?? this.isDeletedRocket,
    );
  }

  @override
  List<Object?> get props => [isDeletedBullet, isDeletedRocket];
}

class _FireworkWidgetState extends State<FireworkWidget>
    with TickerProviderStateMixin<FireworkWidget> {
  late AnimationController fireworkController;
  late AnimationController explosionController;

  late Animation<double> rocketAnimation;
  late Animation<double> explosionEffectAnimation;
  late Animation<double> scaleAnimation; // scale bullet to disappear

  //audio
  late AudioPlayer rocketAudioPlayer = AudioPlayer();
  late AudioPlayer explosionAudioPlayer = AudioPlayer();

  late StreamController<FireworkState> streamController;
  Stream<bool> get deletedRocketStream =>
      streamController.stream.map((state) => state.isDeletedRocket).distinct();
  Stream<bool> get deletedBulletStream =>
      streamController.stream.map((state) => state.isDeletedBullet).distinct();

  int get version => widget.version;
  double get distance => widget.distance;
  double get positionFromLeft => widget.positionFromLeft;
  double get scaleSpace => widget.scaleSpace;
  double get startToExplosionTime => widget.explosionTime;
  double get explodeToScaleBulletTime => widget.fadeAwayTime;
  double get explosionEffectRadius => widget.explosionEffectRadius;
  Duration get fireworkDuration => widget.fireworkDuration;
  Key get key => widget.key!;
  List<Color> get colors => widget.colors;
  bool get mutevolume => widget.muteVolume;

  late List<ChainBullet> chainBullets;
  late List<ChainBulletV2> chainBulletsV2;
  late Timer explosionTimer;

  @override
  void initState() {
    super.initState();
    // setup chain bullets
    if (version == 2) {
      chainBulletsV2 =
          List.generate(150, (index) => ChainBulletV2.index(index));
    } else {
      // v1
      chainBullets = List.generate(150, (index) => ChainBullet.index(index));
    }

    // setup animation
    fireworkController =
        AnimationController(vsync: this, duration: fireworkDuration);
    explosionController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    streamController = StreamController.broadcast();

    rocketAnimation = Tween<double>(begin: 0, end: distance).animate(
        CurvedAnimation(
            parent: fireworkController,
            curve:
                Interval(0, startToExplosionTime, curve: Curves.easeOutCubic)));
    scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: fireworkController,
      curve: Interval(explodeToScaleBulletTime, 1, curve: Curves.elasticInOut),
    ));

    // explosion
    explosionEffectAnimation =
        Tween<double>(begin: 0, end: explosionEffectRadius).animate(
            CurvedAnimation(
                parent: explosionController, curve: Curves.easeOutQuart));

    fireworkController.addStatusListener((status) {
      debugPrint("addStatusListener $status");
      if (fireworkController.isCompleted) {
        streamController.add(const FireworkState(
          isDeletedBullet: true,
        ));
      }
      if (status == AnimationStatus.forward && mutevolume) {
        rocketAudioPlayer.play();
      }
    });

    explosionController.addStatusListener((status) {
      if (explosionController.isCompleted) {
        explosionController.reverse();
        streamController.add(const FireworkState(
          isDeletedRocket: true,
        ));
      }
      if (status == AnimationStatus.forward && mutevolume) {
        explosionAudioPlayer.play();
      }
    });

    // setup audio
    setupAudio();
    fireworkController.forward();

    explosionTimer = Timer(
      Duration(
          milliseconds: (fireworkDuration.inMilliseconds *
              (startToExplosionTime)) as int),
      () {
        explosionController.forward();
      },
    );
  }

  void setupAudio() async {
    await rocketAudioPlayer.setAsset("audio/rocket.mp3");
    await explosionAudioPlayer.setAsset("audio/explosion.mp3");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Positioned(
          bottom: 0,
          left: positionFromLeft,
          child: StreamProvider<Stream<bool>>(
            stream: deletedRocketStream,
            child: RocketAnimation(
                rocketAnimation: rocketAnimation,
                distance: distance,
                colors: colors),
          ),
        ),
        Positioned(
          bottom: distance,
          left: positionFromLeft,
          child: ExplosionEffectAnimation(
              explosionEffectAnimation: explosionEffectAnimation),
        ),
        ...getExplosion(),
      ],
    );
  }

  List<Positioned> getExplosion() {
    List<Positioned> widgets = [];
    if (version == 2) {
      for (int i = 0; i < chainBulletsV2.length; i++) {
        widgets.add(Positioned(
          bottom: distance,
          left: positionFromLeft,
          child: StreamProvider<Stream<bool>>(
            stream: deletedBulletStream,
            child: ExplosionV2Animation(
              index: i,
              fireworkController: fireworkController,
              chainBullet: chainBulletsV2[i],
              startToExplosionTime: startToExplosionTime,
              explodeToScaleBulletTime: explodeToScaleBulletTime,
              scaleAnimation: scaleAnimation,
              scaleSpace: scaleSpace,
              colors: colors,
            ),
          ),
        ));
      }
    } else {
      for (int i = 0; i < chainBullets.length; i++) {
        widgets.add(Positioned(
          bottom: distance,
          left: positionFromLeft,
          child: StreamProvider<Stream<bool>>(
            stream: deletedBulletStream,
            child: ExplosionAnimation(
              index: i,
              fireworkController: fireworkController,
              chainBullet: chainBullets[i],
              startToExplosionTime: startToExplosionTime,
              explodeToScaleBulletTime: explodeToScaleBulletTime,
              scaleAnimation: scaleAnimation,
              scaleSpace: scaleSpace,
              colors: colors,
            ),
          ),
        ));
      }
    }
    return widgets;
  }

  @override
  void dispose() {
    rocketAudioPlayer.dispose();
    explosionAudioPlayer.dispose();
    streamController.close();
    explosionController.dispose();
    fireworkController.dispose();
    explosionTimer.cancel();
    super.dispose();
  }
}
