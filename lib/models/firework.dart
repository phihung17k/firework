import 'package:flutter/material.dart';

class Firework {
  String? key;
  double? distance;
  double? positionFromLeft;
  double? scaleSpace; // scale the whole firework
  Duration? duration;
  double? explosionTime;
  double? fadeAwayTime;
  double? explosionEffectRadius;
  List<Color>? colors;
  bool? mute; // default false

  Firework({
    this.key,
    this.distance,
    this.positionFromLeft,
    this.scaleSpace,
    this.duration,
    this.explosionTime,
    this.fadeAwayTime,
    this.explosionEffectRadius,
    this.colors,
    this.mute = false,
  });
}
