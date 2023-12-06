import 'dart:math';
import 'dart:ui';

class ChainBulletV2 {
  double radiusOfFirework = 200;
  Offset? p1;
  Offset? p2;
  Offset? p3;
  double? radiusOfBullet;

  ChainBulletV2({this.p1, this.p2, this.p3, this.radiusOfBullet = 5});

  ChainBulletV2.index(int index, {this.radiusOfBullet = 5}) {
    Random ran = Random();
    p1 = Offset(50, -200);
    p2 = Offset(100, -250);
    p3 = Offset(130, -150);

    if (index < 10) {
      double y2 = ran.nextInt(50) + 250;
      double y1 = y2 - 50 - ran.nextInt(50);
      double y3 = y2 - 60 - ran.nextInt(50);

      double x1 = ran.nextInt(10) + 1;
      double x2 = x1 + ran.nextInt(50) + 10;
      double x3 = x2 + ran.nextInt(50) + 20;
      p1 = Offset(x1, -y1);
      p2 = Offset(x2, -y2);
      p3 = Offset(x3, -y3);
    } else if (10 <= index && index < 20) {
    } else if (20 <= index && index < 30) {
    } else if (30 <= index && index < 40) {
    } else if (40 <= index && index < 50) {
    } else if (50 <= index && index < 60) {
    } else if (60 <= index && index < 70) {
    } else if (70 <= index && index < 80) {
    } else if (80 <= index && index < 90) {
    } else if (90 <= index && index < 100) {
    } else if (100 <= index && index < 110) {
    } else if (110 <= index && index < 120) {
    } else if (120 <= index && index < 130) {
    } else if (130 <= index && index < 140) {
    } else {}
  }
}
