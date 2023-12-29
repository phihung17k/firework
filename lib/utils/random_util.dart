import 'dart:math';

class RandomUtil {
  static final Random _ran = Random();
  static double ran(double min, double max) {
    if (min > max) {
      double temp = min;
      min = max;
      max = temp;
    }
    return _ran.nextDouble() * (max - min) + min;
  }
}
