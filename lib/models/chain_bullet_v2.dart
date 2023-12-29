import 'dart:math';
import 'dart:ui';

import 'package:firework/utils/random_util.dart';

// Outline of quadrant IV
List<(double, double, double, double, double, double)> quadrant4 = [
  (100, 5, 160, 5, RandomUtil.ran(195, 205), RandomUtil.ran(-15, 0)),
  (100, 5, 160, 5, RandomUtil.ran(195, 205), RandomUtil.ran(-25, -15)),
  (100, 5, 160, 0, RandomUtil.ran(195, 205), RandomUtil.ran(-35, -25)),
  (100, 0, 160, -5, RandomUtil.ran(195, 200), RandomUtil.ran(-40, -35)),
  (100, -5, 160, -10, RandomUtil.ran(195, 200), RandomUtil.ran(-45, -40)),
  (100, -5, 160, -15, RandomUtil.ran(190, 200), RandomUtil.ran(-50, -45)),
  (100, -10, 160, -20, RandomUtil.ran(190, 195), RandomUtil.ran(-55, -50)),
  (100, -10, 160, -25, RandomUtil.ran(190, 195), RandomUtil.ran(-65, -55)),
  (100, -15, 160, -30, RandomUtil.ran(185, 190), RandomUtil.ran(-75, -65)),
  (100, -15, 160, -40, RandomUtil.ran(180, 190), RandomUtil.ran(-80, -75)),
  (95, -15, 165, -35, RandomUtil.ran(190, 195), RandomUtil.ran(-90, -75)),
  (95, -30, 155, -65, RandomUtil.ran(175, 185), RandomUtil.ran(-130, -110)),
  (95, -40, 145, -80, RandomUtil.ran(170, 175), RandomUtil.ran(-145, -130)),
  (95, -55, 135, -95, RandomUtil.ran(155, 160), RandomUtil.ran(-165, -150)),
  (85, -70, 120, -105, RandomUtil.ran(135, 140), RandomUtil.ran(-180, -165)),
  (80, -80, 110, -125, RandomUtil.ran(120, 125), RandomUtil.ran(-195, -180)),
  (70, -85, 95, -135, RandomUtil.ran(100, 110), RandomUtil.ran(-195, -190)),
  (55, -95, 75, -135, RandomUtil.ran(80, 90), RandomUtil.ran(-200, -195)),
  (45, -95, 60, -140, RandomUtil.ran(60, 70), RandomUtil.ran(-205, -200)),
  (35, -100, 45, -140, RandomUtil.ran(50, 55), RandomUtil.ran(-210, -200)),
  (20, -100, 31, -145, RandomUtil.ran(30, 35), RandomUtil.ran(-215, -200)),
  (12.5, -100, 17, -145.5, 20, RandomUtil.ran(-215, -205)),
  (9.5, -125, 10, -170, 9.5, RandomUtil.ran(-220, -210)),
];

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
    } else if (index > 14 && index < 36) {
      var record = quadrant4[index - 15];
      x1 = record.$1;
      y1 = record.$2;
      x2 = record.$3;
      y2 = record.$4;
      x3 = record.$5;
      y3 = record.$6;
    }

    p1 = Offset(x1, -y1);
    p2 = Offset(x2, -y2);
    p3 = Offset(x3, -y3);
  }
}
