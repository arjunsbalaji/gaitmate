import 'dart:async';
import 'package:flutter/material.dart';

class MyStopwatch extends ChangeNotifier {
  int counter = 0;

  String get totalDuration {
    return "${Duration(seconds: counter).inHours.toString().padLeft(2, "0")}:${Duration(seconds: counter).inMinutes.remainder(60).toString().padLeft(2, "0")}:${(Duration(seconds: counter).inSeconds.remainder(60)).toString().padLeft(2, "0")}";
  }

  Timer timer;
  final Duration dur = Duration(seconds: 1);

  MyStopwatch();

  void tick(_) {
    counter++;
    notifyListeners();
  }

  void start() {
    timer = Timer.periodic(dur, tick);
  }

  void pause() {
    assert(timer != null);
    timer.cancel();
    notifyListeners();
  }

  void reset() {
    assert(timer != null);
    timer.cancel();
    counter = 0;
    notifyListeners();
  }
}
