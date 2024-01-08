import 'package:firework/chain_bullet_widget.dart';
import 'package:firework/firework_widget.dart';
import 'package:firework/rocket_widget.dart';
import 'package:firework/explosion_widget.dart';
import 'package:firework/sample_widget.dart';
import 'package:firework/screen.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/rendering.dart';

class Routes {
  static String get explosion => '/explosion';
  static String get rocket => '/rocket';
  static String get chainBullet => '/chainBullet';
  static String get sample => '/sample';
  static String get firework => '/firework';
  static String get screen => '/screen';
}

void main(List<String> args) {
  // debugRepaintRainbowEnabled = true;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: Routes.screen,
    routes: {
      Routes.explosion: (context) => const ExplosionWidget(),
      Routes.rocket: (context) => const RocketWidget(),
      Routes.chainBullet: (context) => const ChainBulletWidget(),
      Routes.sample: (context) => const SampleWidget(),
      Routes.firework: (context) => const FireworkWidget(),
      Routes.screen: (context) => const Screen(),
    },
  ));
}
