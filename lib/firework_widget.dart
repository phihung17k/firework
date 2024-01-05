import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firework/animations/explosion_animation.dart';
import 'package:firework/models/chain_bullet.dart';
import 'package:firework/models/chain_bullet_v2.dart';
import 'package:flutter/material.dart';

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

  late List<ChainBullet> chainBullets;
  late List<ChainBulletV2> chainBulletsV2;
  late Timer explosionTimer;

  @override
  void initState() {
    // debugPrint("init ${key.toString()}");
    super.initState();
    if (version == 2) {
      chainBulletsV2 =
          List.generate(150, (index) => ChainBulletV2.index(index));
    } else {
      // v1
      chainBullets = List.generate(150, (index) => ChainBullet.index(index));
    }

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

    fireworkController.forward();
    fireworkController.addStatusListener((status) {
      if (fireworkController.isCompleted) {
        streamController.add(const FireworkState(
          isDeletedBullet: true,
        ));
      }
    });

    // explosion
    explosionEffectAnimation =
        Tween<double>(begin: 0, end: explosionEffectRadius).animate(
            CurvedAnimation(
                parent: explosionController, curve: Curves.easeOutQuart));

    explosionTimer = Timer(
      Duration(
          milliseconds: (fireworkDuration.inMilliseconds *
              (startToExplosionTime)) as int),
      () {
        explosionController.forward();
      },
    );

    explosionController.addStatusListener((status) {
      if (explosionController.isCompleted) {
        explosionController.reverse();
        streamController.add(const FireworkState(
          isDeletedRocket: true,
        ));
      }
    });
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
                rocketAnimation: rocketAnimation, distance: distance),
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
            ),
          ),
        ));
      }
    }

    return widgets;
  }

  @override
  void dispose() {
    // debugPrint("dispose ${key.toString()}");
    streamController.close();
    explosionController.dispose();
    fireworkController.dispose();
    explosionTimer.cancel();
    super.dispose();
  }
}
