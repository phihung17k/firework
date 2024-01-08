import 'dart:math';

class ChainBullet {
  double? totalDistance;
  double? angle;
  double? radiusOfBullet;

  ChainBullet({this.totalDistance, this.angle, this.radiusOfBullet = 5});

  ChainBullet.index(int index) {
    if (index < 45) {
      totalDistance = Random().nextDouble() * 15 + 195;
      angle = index * 8;
      radiusOfBullet = Random().nextDouble() * 3 + 1;
    } else if (index >= 45 && index < 75) {
      totalDistance = Random().nextDouble() * 25 + 175;
      angle = (index - 45) * 12;
      radiusOfBullet = Random().nextDouble() * 3 + 1;
    } else if (index >= 75 && index < 95) {
      totalDistance = Random().nextDouble() * 20 + 150;
      angle = (index - 75) * 18;
      radiusOfBullet = Random().nextDouble() * 3 + 2;
    } else if (index >= 95 && index < 115) {
      totalDistance = Random().nextDouble() * 20 + 120;
      angle = (index - 95) * 22;
      radiusOfBullet = Random().nextDouble() * 3 + 1;
    } else if (index >= 115 && index < 130) {
      totalDistance = Random().nextDouble() * 20 + 90;
      angle = (index - 115) * 25;
      radiusOfBullet = Random().nextDouble() * 3 + 2;
    } else {
      totalDistance = Random().nextDouble() * 50 + 30;
      angle = (index - 130) * 28;
      radiusOfBullet = Random().nextDouble() * 3 + 1;
    }
  }
}
