import 'package:firework/chain_bullet_widget.dart';
import 'package:firework/firework_page.dart';
import 'package:firework/rocket_widget.dart';
import 'package:firework/explosion_widget.dart';
import 'package:firework/sample_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Routes {
  static String get explosion => '/explosion';
  static String get rocket => '/rocket';
  static String get chainBullet => '/chainBullet';
  static String get sample => '/sample';
  static String get firework => '/firework';
}

void main(List<String> args) {
  debugRepaintRainbowEnabled = true;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // theme: ThemeData(
    //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    //   // primaryColor: Colors.blue,
    //   // useMaterial3: true,
    // ),
    initialRoute: Routes.explosion,
    routes: {
      Routes.explosion: (context) => const ExplosionWidget(),
      Routes.rocket: (context) => const RocketWidget(),
      Routes.chainBullet: (context) => const ChainBulletWidget(),
      Routes.sample: (context) => const SampleWidget(),
      Routes.firework: (context) => const FireworkPage(),
    },
  ));
}
