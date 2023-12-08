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
      x1 = x1 + ran.nextInt(5); // 30 - 35
      y1 = y1 - 130 + ran.nextInt(150);

      x2 = x1 + 10 + ran.nextInt(15); // 45 - 60
      y2 = y1 + 30 + ran.nextInt(25);

      x3 = x2 + 10 + ran.nextInt(20); // 70 - 90
      y3 = y1;
    } else if (11 <= index && index < 15) {
      // origin
      x1 = 30;
      y1 = 170;
      // x2 = 80;
      // y2 = 210;
      // x3 = 110;
      // y3 = 170;

      // variant
      x1 = x1 + ran.nextInt(5); // 30 - 35
      y1 = y1 - 50 + ran.nextInt(80); // 120 - 200

      x2 = x1 + 30 + ran.nextInt(25); // 60 - 85
      y2 = y1 + 30 + ran.nextInt(25); // 230 - 255

      x3 = x2 + 30 + ran.nextInt(20); // 95 - 115
      y3 = y1;
    } else if (15 <= index && index < 20) {
      // origin
      x1 = 70;
      y1 = 140;
      // x2 = 130;
      // y2 = 160;
      // x3 = 170;
      // y3 = 140;

      // variant
      x1 = x1 + ran.nextInt(10); // 70 - 80
      y1 = y1 - 70 + ran.nextInt(80); // 70 - 150

      x2 = x1 + 20 + ran.nextInt(20); // 100 - 120
      y2 = y1 + 20 + ran.nextInt(20); // 210 - 245

      x3 = x2 + 20 + ran.nextInt(30); // 140 - 170
      y3 = y1;
    } else if (20 <= index && index < 25) {
      // origin
      x1 = 100;
      y1 = 110;
      // x2 = 140;
      // y2 = 130;
      // x3 = 180;
      // y3 = 110;

      // variant
      x1 = x1 + ran.nextInt(20); // 100 - 120
      y1 = y1 - 60 + ran.nextInt(80); // 60 - 120

      x2 = x1 + 20 + ran.nextInt(20); // 140 - 160
      y2 = y1 + 10 + ran.nextInt(20); // 130 - 150

      x3 = x2 + 20 + ran.nextInt(20); // 180 - 200
      y3 = y1;
    } else if (25 <= index && index < 30) {
      // origin
      x1 = 110;
      y1 = 50;
      // x2 = 160;
      // y2 = 70;
      // x3 = 200;
      // y3 = 50;

      // variant
      x1 = x1 + ran.nextInt(20); // 110 - 130
      y1 = y1 - 40 + ran.nextInt(50); // 10 - 60

      x2 = x1 + 10 + ran.nextInt(20); // 140 - 150
      y2 = y1 + 10 + ran.nextInt(20); // 60 - 80

      x3 = x2 + 20 + ran.nextInt(40); // 170 - 200
      y3 = y1;
    } else if (30 <= index && index < 35) {
      // origin
      x1 = 100;
      y1 = 10;
      // x2 = 160;
      // y2 = 10;
      // x3 = 200;
      // y3 = -10;

      // variant
      x1 = x1 + ran.nextInt(20); // 100 - 120
      y1 = y1 - 20 + ran.nextInt(40); // -10 - 10

      x2 = x1 + 20 + ran.nextInt(20); // 140 - 160
      y2 = y1 + 10 - ran.nextInt(30); // 10 - -10

      x3 = x2 + 10 + ran.nextInt(50); // 170 - 200
      y3 = y2 - 10 - ran.nextInt(30); // -20 - -40
    } else if (35 <= index && index < 40) {
      // origin
      x1 = 110;
      y1 = -30;
      // x2 = 160;
      // y2 = -60;
      // x3 = 190;
      // y3 = -90;

      // variant
      x1 = x1 + ran.nextInt(10); // 110 - 120
      y1 = y1 - 5 + ran.nextInt(15); // -35 - -20

      x2 = x1 + 20 + ran.nextInt(30); // 150 - 170
      y2 = y1 - 0 - ran.nextInt(20); // -20 - -40

      x3 = x2 + 0 + ran.nextInt(30); // 170 - 200
      y3 = y2 - 0 - ran.nextInt(60); // -40 - -100
    } else if (40 <= index && index < 45) {
      // origin
      x1 = 70;
      y1 = -50;
      // x2 = 160;
      // y2 = -60;
      // x3 = 190;
      // y3 = -90;

      // variant
      x1 = x1 + ran.nextInt(10); // 70 - 80
      // y1 = y1 - 5 + ran.nextInt(15); // -35 - -20

      x2 = x1 + 40 + ran.nextInt(10); // 120 - 130
      y2 = -80; // -20 - -40

      x3 = x2 - 10 + ran.nextInt(40); // 130 - 160
      y3 = -90 - ran.nextInt(70) + 0; // -40 - -100
    } else if (45 <= index && index < 48) {
      // origin
      x1 = 50;
      y1 = -70;
      // x2 = 160;
      // y2 = -60;
      // x3 = 190;
      // y3 = -90;

      // variant
      // x1 = x1 + ran.nextInt(10); // 70 - 80
      // y1 = y1 - 5 + ran.nextInt(15); // -35 - -20

      x2 = 70; // 120 - 130
      y2 = -100; // -20 - -40

      x3 = x2 + ran.nextInt(30); // 130 - 160
      y3 = y2 - 70 - ran.nextInt(30) + 0; // -40 - -100
      // } else if (110 <= index && index < 120) {
      // } else if (120 <= index && index < 130) {
      // } else if (130 <= index && index < 140) {
    } else if (48 <= index && index < 55) {
      // origin
      // x1 = 0;
      // y1 = 0;
      // // x2 = 160;
      // // y2 = -60;
      // // x3 = 190;
      // // y3 = -90;

      // // variant
      // // x1 = x1 - ran.nextInt(30); // 70 - 80
      // // y1 = y1 - 5 + ran.nextInt(15); // -35 - -20

      // x2 = x1; // 120 - 130
      // y2 = y1; // -20 - -40

      x3 = ran.nextInt(50) + 0; // 130 - 160
      y3 = -100 - ran.nextInt(100) + 0; // -40 - -100
      x1 = x3;
      y1 = y3;
      x2 = x3;
      y2 = y3;

      // } else if (110 <= index && index < 120) {
      // } else if (120 <= index && index < 130) {
      // } else if (130 <= index && index < 140) {
    } else if (3 <= index && index < 140) {
      // y2 = 100;
      // y1 = 100;
      // y3 = 100;
      // x1 = 100;
      // x2 = 100;
      // x3 = 100;
    }

    p1 = Offset(x1, -y1);
    p2 = Offset(x2, -y2);
    p3 = Offset(x3, -y3);
  }
}
