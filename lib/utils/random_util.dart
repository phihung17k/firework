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

  static int ranInt(int min, int max) {
    if (min > max) {
      int temp = min;
      min = max;
      max = temp;
    }
    return _ran.nextInt(max - min) + min;
  }
}
