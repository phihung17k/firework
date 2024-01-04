import 'dart:math';
import 'dart:ui';

import 'package:firework/utils/random_util.dart';

class ChainBulletV2 {
  // double radiusOfFirework = 200;
  Offset? p1;
  Offset? p2;
  Offset? p3;
  double? radiusOfBullet;

  ChainBulletV2({this.p1, this.p2, this.p3, this.radiusOfBullet = 5});

  ChainBulletV2.index(int index, {this.radiusOfBullet = 5}) {
    double radiusOfFirework = 0;
    double alpha = RandomUtil.ran(0, 360);
    if (index < 45) {
      radiusOfFirework = RandomUtil.ran(190, 210);
    } else {
      radiusOfFirework = RandomUtil.ran(50, 180);
    }

    double radian = alpha * pi / 180;
    double x3 = radiusOfFirework * cos(radian);
    double y3 = radiusOfFirework * sin(radian);

    double x1 = x3 - 30;
    double y1 = y3 + 30;
    double x2 = x1;
    double y2 = y1;

    p1 = Offset(x1, -y1);
    p2 = Offset(x2, -y2);
    p3 = Offset(x3, -y3);
  }
}
