import 'dart:math';

class RandomUtil {
  static final Random _ran = Random();
  static double ran(double min, double max) {
    return _ran.nextDouble() * (max - min) + min;
  }
}
