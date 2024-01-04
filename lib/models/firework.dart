class Firework {
  String? key;
  double? distance;
  double? positionFromLeft;
  double? scaleSpace; // scale the whole firework
  Duration? duration;
  double? explosionTime;
  double? fadeAwayTime;
  double? explosionEffectRadius;

  Firework({
    this.key,
    this.distance,
    this.positionFromLeft,
    this.scaleSpace,
    this.duration,
    this.explosionTime,
    this.fadeAwayTime,
    this.explosionEffectRadius,
  });
}
