import 'dart:math';

import 'package:flutter/material.dart';
import 'activity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Collection with ChangeNotifier {
  final String title;
  final String description;
  final List<String> types = ['Runs', 'Walks'];

  List<Activity> _activities = [
    Activity(
        id: 'first',
        startTime: DateTime.utc(2020, 6, 4, 8, 10),
        duration: Duration(seconds: 20),
        type: 'run',
        endTime: DateTime.utc(2020, 6, 4, 10, 10),
        data: {'gyro': 1, 'lin': 0, 'value': 100},
        notes: 'Description for activity.'),
    Activity(
        id: 'second',
        startTime: DateTime.utc(2020, 6, 4, 8, 10),
        duration: Duration(seconds: 20),
        type: 'run',
        endTime: DateTime.utc(2020, 6, 4, 10, 10),
        data: {'gyro': 1, 'lin': 0, 'value': 100},
        notes: 'Description for activity.'),
    Activity(
        id: 'third',
        startTime: DateTime.utc(2020, 6, 4, 8, 10),
        duration: Duration(seconds: 20),
        endTime: DateTime.utc(2020, 6, 4, 10, 10),
        data: {'gyro': 1, 'lin': 0, 'value': 100},
        type: 'run',
        notes: 'Description for activity.'),
    Activity(
        id: 'fourth',
        startTime: DateTime.utc(2020, 6, 4, 8, 10),
        duration: Duration(seconds: 20),
        type: 'run',
        endTime: DateTime.utc(2020, 6, 4, 10, 10),
        data: {'gyro': 1, 'lin': 0, 'value': 100},
        notes: 'Description for activity.'),
    Activity(
        id: 'fifth',
        startTime: DateTime.utc(2020, 6, 4, 8, 10),
        duration: Duration(seconds: 20),
        type: 'run',
        endTime: DateTime.utc(2020, 6, 4, 10, 10),
        data: {'gyro': 1, 'lin': 0, 'value': 100},
        notes: 'Description for activity.'),
    Activity(
        id: 'sixth',
        startTime: DateTime.utc(2020, 6, 4, 8, 10),
        duration: Duration(seconds: 20),
        type: 'walk',
        endTime: DateTime.utc(2020, 6, 4, 10, 10),
        data: {'gyro': 1, 'lin': 0, 'value': 100},
        notes: 'Description for activity.'),
    Activity(
        id: 'seventh',
        startTime: DateTime.utc(2020, 6, 4, 8, 10),
        duration: Duration(seconds: 20),
        type: 'walk',
        endTime: DateTime.utc(2020, 6, 4, 10, 10),
        data: {'gyro': 1, 'lin': 0, 'value': 100},
        notes: 'Description for activity.'),
    Activity(
        id: 'ninth',
        startTime: DateTime.utc(2020, 6, 4, 8, 10),
        duration: Duration(seconds: 20),
        type: 'walk',
        endTime: DateTime.utc(2020, 6, 4, 10, 10),
        data: {'gyro': 1, 'lin': 0, 'value': 100},
        notes: 'Description for activity.'),
  ];

  Collection(
    this.title,
    this.description,
  );

  List<Activity> get activities {
    return [..._activities];
  }

  List<Activity> getActvitiesByType(String type) {
    return _activities.where((act) => (act.type == type)).toList();
  }

  Future<void> addActivity(String notes, String type, Map<String, Object> data,
      DateTime startTime, Duration duration, DateTime endTime) async {
    const url = 'https://gaitmate.firebaseio.com/activities.json';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'notes': notes,
            'type': type,
            'data': data,
            'startTime': startTime.toString(),
            'duration': duration.toString(),
            'endTime': endTime.toString(),
          },
        ),
      );
      final newActivity = Activity(
        id: json.decode(response.body)['name'],
        data: data,
        type: type,
        duration: duration,
        notes: notes,
        startTime: startTime,
        endTime: endTime,
      );
      _activities.add(newActivity);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  void removeActivity(String id) {}
}
