import 'package:flutter/material.dart';

class Activity {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final Object value;
  final String notes;
  //potentially lots more stuff here like what device it was recorded from etc. also could have streams if we get real time data =>

  Activity({
    @required this.id,
    @required this.startTime,
    @required this.endTime,
    @required this.value,
    @required this.notes,
  });
}
