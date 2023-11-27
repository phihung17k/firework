import 'dart:math';

class ChainBullet {
  double? totalDistance;
  // double angle = Random().nextDouble() * 360;
  double? angle;

  ChainBullet({int? index}) {
    if (index! < 45) {
      totalDistance = Random().nextDouble() * 15 + 195;
      angle = index * 8;
    } else if (index >= 45 && index < 75) {
      totalDistance = Random().nextDouble() * 25 + 175;
      angle = (index - 45) * 12;
    } else if (index >= 75 && index < 95) {
      totalDistance = Random().nextDouble() * 20 + 150;
      angle = (index - 75) * 18;
    } else if (index >= 95 && index < 115) {
      totalDistance = Random().nextDouble() * 20 + 120;
      angle = (index - 95) * 22;
    } else if (index >= 115 && index < 130) {
      totalDistance = Random().nextDouble() * 20 + 90;
      angle = (index - 115) * 25;
    } else {
      totalDistance = Random().nextDouble() * 50 + 30;
      angle = (index - 130) * 28;
    }
  }
}
