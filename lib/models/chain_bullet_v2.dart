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

    double x1 = 0, x2 = 5, x3 = 6;
    double y1 = 200, y2 = 250, y3 = 200;

    if (1 <= index && index < 3) {
      // origin
      x1 = 0;
      y1 = 200;
      x2 = 5;
      y2 = 250;
      x3 = 6;
      // y3 = y1;

      // variant
      x1 = x1 + ran.nextInt(5) + 0; //0-5
      y1 = y1 - 150 + ran.nextInt(130);

      x2 = x1 + 5 + ran.nextInt(5); // 5-10
      y2 = y1 + 50;

      x3 = x2 + 5 + ran.nextInt(5);
      y3 = y1;
    } else if (3 <= index && index < 6) {
      // origin
      x1 = 5;
      y1 = 200;
      // x2 = 25;
      // y2 = 240;
      // x3 = 40;
      // y3 = y1;

      // variant
      x1 = x1 + ran.nextInt(5); // 5-10
      y1 = y1 - 150 + ran.nextInt(150);

      x2 = x1 + 10 + ran.nextInt(15); // 25 - 40
      y2 = y1 + 30 + ran.nextInt(25);

      x3 = x2 + 10 + ran.nextInt(10); // 55 - 65
      y3 = y1;
    } else if (6 <= index && index < 11) {
      // origin
      x1 = 30;
      y1 = 170;
      // x2 = 80;
      // y2 = 210;
      // x3 = 110;
      // y3 = y1;

      // variant
      x1 = x1 + ran.nextInt(5); // 40 - 45
      y1 = y1 - 130 + ran.nextInt(150);

      x2 = x1 + 10 + ran.nextInt(15); // 50 - 65
      y2 = y1 + 30 + ran.nextInt(25);

      x3 = x2 + 10 + ran.nextInt(20); // 75 - 95
      y3 = y1;
    } else if (11 <= index && index < 15) {
      // origin
      x1 = 50;
      y1 = 160;
      // x2 = 90;
      // y2 = 190;
      // x3 = 120;
      // y3 = 160;

      // variant
      x1 = x1 + ran.nextInt(5); // 40 - 45
      y1 = y1 - 130 + ran.nextInt(150);

      x2 = x1 + 10 + ran.nextInt(15); // 50 - 65
      y2 = y1 + 30 + ran.nextInt(25);

      x3 = x2 + 10 + ran.nextInt(20); // 75 - 95
      y3 = y1;
      // } else if (13 <= index && index < 18) {
      // } else if (18 <= index && index < 25) {
      // } else if (60 <= index && index < 70) {
      // } else if (70 <= index && index < 80) {
      // } else if (80 <= index && index < 90) {
      // } else if (90 <= index && index < 100) {
      // } else if (100 <= index && index < 110) {
      // } else if (110 <= index && index < 120) {
      // } else if (120 <= index && index < 130) {
      // } else if (130 <= index && index < 140) {
    } else if (3 <= index && index < 140) {
      y2 = 100;
      y1 = 100;
      y3 = 100;
      x1 = 100;
      x2 = 100;
      x3 = 100;
    }

    p1 = Offset(x1, -y1);
    p2 = Offset(x2, -y2);
    p3 = Offset(x3, -y3);
  }
}
