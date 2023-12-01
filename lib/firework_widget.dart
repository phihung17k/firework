import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firework/models/chain_bullet.dart';
import 'package:firework/painters/chain_bullet_painter.dart';
import 'package:firework/painters/rocket_painter.dart';
import 'package:flutter/material.dart';

import 'painters/explosion_painter.dart';

class FireworkWidget extends StatefulWidget {
  final double distance;
  final double positionFromLeft;
  final double scaleSpace;
  final Duration fireworkDuration;
  final double explosionTime;
  final double fadeAwayTime;
  final double explosionEffectRadius;

  const FireworkWidget({
    super.key,
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
  late Animation<double> explosionBulletAnimation;
  late Animation<double> scaleAnimation;

  late StreamController<FireworkState> streamController;
  Stream<bool> get rocketStream =>
      streamController.stream.map((state) => state.isDeletedRocket).distinct();
  Stream<bool> get bulletStream =>
      streamController.stream.map((state) => state.isDeletedBullet).distinct();

  double get distance => widget.distance;
  double get positionFromLeft => widget.positionFromLeft;
  double get scaleSpace => widget.scaleSpace;
  double get startToExplosionTime => widget.explosionTime;
  double get explodeToScaleBulletTime => widget.fadeAwayTime;
  double get explosionEffectRadius => widget.explosionEffectRadius;
  Duration get fireworkDuration => widget.fireworkDuration;

  bool isDeletedRocket = false;
  bool isDeletedBullet = false;
  List<ChainBullet> chainBullets =
      List.generate(150, (index) => ChainBullet(index: index));
  late Timer explosionTimer;

  @override
  void initState() {
    super.initState();

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
        // setState(() {
        //   isDeletedBullet = true;
        // });
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
        // setState(() {
        //   isDeletedRocket = true;
        // });
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
          child: RepaintBoundary(
            key: const ValueKey("repaint rocketAnimation"),
            child: AnimatedBuilder(
              animation: rocketAnimation,
              builder: (context, _) {
                return StreamBuilder<bool>(
                    stream: rocketStream,
                    builder: (context, snapshot) {
                      return CustomPaint(
                        key: const ValueKey("rocketAnimation"),
                        painter: RocketPainter(
                            totalDistance: distance,
                            currentDistance: rocketAnimation.value,
                            isDeleted: snapshot.data ?? false),
                      );
                    });
              },
            ),
          ),
        ),
        Positioned(
          bottom: distance,
          left: positionFromLeft,
          child: RepaintBoundary(
            key: const ValueKey("repaint explosionEffectAnimation"),
            child: AnimatedBuilder(
              animation: explosionEffectAnimation,
              builder: (context, _) {
                return CustomPaint(
                  key: const ValueKey("explosionEffectAnimation"),
                  painter:
                      ExplosionPainter(radius: explosionEffectAnimation.value),
                );
              },
            ),
          ),
        ),
        for (int i = 0; i < chainBullets.length; i++)
          Positioned(
            bottom: distance,
            left: positionFromLeft,
            child: RepaintBoundary(
              key: ValueKey("repaint $i"),
              child: AnimatedBuilder(
                animation: fireworkController,
                builder: (context, _) {
                  var chainBullet = chainBullets[i];
                  explosionBulletAnimation = Tween<double>(
                          begin: 0, end: chainBullet.totalDistance)
                      .animate(CurvedAnimation(
                          parent: fireworkController,
                          curve: Interval(
                              startToExplosionTime, explodeToScaleBulletTime,
                              curve: Curves.easeOutSine)));
                  // scale bullet
                  if (scaleAnimation.value < 1) {
                    chainBullet.radiusOfBullet =
                        chainBullet.radiusOfBullet! * scaleAnimation.value;
                  }
                  return StreamBuilder<bool>(
                      stream: bulletStream,
                      builder: (context, snapshot) {
                        return CustomPaint(
                          key: ValueKey("explosionBulletAnimation $i"),
                          painter: ChainBulletPainter(
                            totalDistance: chainBullet.totalDistance!,
                            currentDistance: explosionBulletAnimation.value,
                            angle: chainBullet.angle!,
                            isDeleted: snapshot.data ?? false,
                            radiusOfBullet: chainBullet.radiusOfBullet!,
                            totalPoint: 10,
                            scaleSpace: scaleSpace,
                          ),
                        );
                      });
                },
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    streamController.close();
    explosionController.dispose();
    fireworkController.dispose();
    explosionTimer.cancel();
    super.dispose();
  }
}
