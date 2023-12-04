import 'package:flutter/material.dart';

class StreamProvider<T> extends InheritedWidget {
  final T stream;

  const StreamProvider({super.key, required this.stream, required super.child});

  static T? maybeOf<T>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<StreamProvider<T>>()
        ?.stream;
  }

  static T? of<T>(BuildContext context) {
    final T? stream = maybeOf(context);
    assert(stream != null, "No $T found in context");
    return stream;
  }

  @override
  bool updateShouldNotify(covariant StreamProvider<T> oldWidget) {
    return oldWidget.stream != stream;
  }
}
