import 'dart:math';

import 'package:flutter/material.dart';

class SampleWidget extends StatefulWidget {
  const SampleWidget({super.key});

  @override
  State<SampleWidget> createState() => _SampleWidgetState();
}

class _SampleWidgetState extends State<SampleWidget> {
  var offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("AAAAAAAAAAAAAAAAAAAA"),
      ),
      body: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(offset.dy * pi / 180)
            ..rotateY(offset.dx * pi / 180),
          alignment: Alignment.center,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                // offset += details.delta
                // <=> offset.dx += details.delta.dx
                // and offset.dy += details.delta.dy
                offset = offset + Offset(-details.delta.dx, details.delta.dy);
              });
            },
            child: Center(
              child: Cube(),
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Cube extends StatelessWidget {
  const Cube({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: FlutterLogo(size: 200),
    );
  }
}
