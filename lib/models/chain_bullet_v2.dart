import 'dart:math';
import 'dart:ui';

import 'package:firework/utils/random_util.dart';

class ChainBulletV2 {
  double radiusOfFirework = 200;
  Offset? p1;
  Offset? p2;
  Offset? p3;
  double? radiusOfBullet;

  ChainBulletV2({this.p1, this.p2, this.p3, this.radiusOfBullet = 5});

  ChainBulletV2.index(int index, {this.radiusOfBullet = 5}) {
    double x1 = 0, x2 = 0, x3 = 0;
    double y1 = 0, y2 = 0, y3 = 0;

    if (index == 0) {
      x1 = 0;
      y1 = 210;
      x2 = 0;
      y2 = 210;
      x3 = RandomUtil.ran(0, 5);
      y3 = 195;
    } else if (1 <= index && index < 3) {
      x3 = RandomUtil.ran(0, 65);
      y3 = RandomUtil.ran(190, 200);
      x1 = x3 - 10;
      y1 = y3 + 20;
      x2 = x3 - 5;
      y2 = y3 + 20;
    } else if (index == 3) {
      x3 = RandomUtil.ran(65, 70);
      y3 = 190;
      x1 = 45;
      y1 = 205;
      x2 = 60;
      y2 = 205;
    } else if (4 <= index && index < 6) {
      x3 = RandomUtil.ran(65, 125);
      y3 = RandomUtil.ran(160, 190);
      x1 = x3 - 35;
      y1 = y3 + 15;
      x2 = x3 - 15;
      y2 = y3 + 15;
    } else if (index == 6) {
      x3 = RandomUtil.ran(125, 130);
      y3 = 160;
      x1 = 90;
      y1 = 175;
      x2 = 110;
      y2 = 175;
    } else if (7 <= index && index < 9) {
      x3 = RandomUtil.ran(125, 170);
      y3 = RandomUtil.ran(105, 160);
      x1 = x3 - 45;
      y1 = y3 + 15;
      x2 = x3 - 20;
      y2 = y3 + 15;
    } else if (index == 9) {
      x3 = RandomUtil.ran(170, 175);
      y3 = 105;
      x1 = 125;
      y1 = 120;
      x2 = 150;
      y2 = 120;
    } else if (10 <= index && index < 12) {
      x3 = RandomUtil.ran(170, 195);
      y3 = RandomUtil.ran(50, 105);
      x1 = x3 - 55;
      y1 = y3 + 20;
      x2 = x3 - 25;
      y2 = y3 + 20;
    } else if (index == 12) {
      x3 = RandomUtil.ran(195, 200);
      y3 = 50;
      x1 = 140;
      y1 = 70;
      x2 = 170;
      y2 = 70;
    } else if (13 <= index && index < 14) {
      x3 = RandomUtil.ran(195, 205);
      y3 = RandomUtil.ran(0, 50);
      x1 = x3 - 70;
      y1 = y3 + 25;
      x2 = x3 - 30;
      y2 = y3 + 25;
    } else if (index == 14) {
      x3 = RandomUtil.ran(205, 210);
      y3 = 0;
      x1 = 135;
      y1 = 25;
      x2 = 175;
      y2 = 25;
    }

    p1 = Offset(x1, -y1);
    p2 = Offset(x2, -y2);
    p3 = Offset(x3, -y3);
  }
}
