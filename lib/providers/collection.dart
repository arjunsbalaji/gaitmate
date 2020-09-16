import 'package:flutter/material.dart';
import 'activity.dart';

class Collection with ChangeNotifier {
  final String title;
  final String description;
  final List<String> types = ['Runs', 'Walks'];

  List<Activity> _activities = [
    Activity(
        id: 'first',
        startTime: DateTime.utc(2020, 6, 4, 8, 10),
        type: 'run',
        endTime: DateTime.utc(2020, 6, 4, 10, 10),
        data: {'gyro': 1, 'lin': 0, 'value': 100},
        notes: 'Description for activity.'),
    Activity(
        id: 'second',
        startTime: DateTime.utc(2020, 6, 4, 8, 10),
        type: 'run',
        endTime: DateTime.utc(2020, 6, 4, 10, 10),
        data: {'gyro': 1, 'lin': 0, 'value': 100},
        notes: 'Description for activity.'),
    Activity(
        id: 'third',
        startTime: DateTime.utc(2020, 6, 4, 8, 10),
        endTime: DateTime.utc(2020, 6, 4, 10, 10),
        data: {'gyro': 1, 'lin': 0, 'value': 100},
        type: 'run',
        notes: 'Description for activity.'),
    Activity(
        id: 'fourth',
        startTime: DateTime.utc(2020, 6, 4, 8, 10),
        type: 'run',
        endTime: DateTime.utc(2020, 6, 4, 10, 10),
        data: {'gyro': 1, 'lin': 0, 'value': 100},
        notes: 'Description for activity.'),
    Activity(
        id: 'fifth',
        startTime: DateTime.utc(2020, 6, 4, 8, 10),
        type: 'run',
        endTime: DateTime.utc(2020, 6, 4, 10, 10),
        data: {'gyro': 1, 'lin': 0, 'value': 100},
        notes: 'Description for activity.'),
    Activity(
        id: 'sixth',
        startTime: DateTime.utc(2020, 6, 4, 8, 10),
        type: 'walk',
        endTime: DateTime.utc(2020, 6, 4, 10, 10),
        data: {'gyro': 1, 'lin': 0, 'value': 100},
        notes: 'Description for activity.'),
    Activity(
        id: 'seventh',
        startTime: DateTime.utc(2020, 6, 4, 8, 10),
        type: 'walk',
        endTime: DateTime.utc(2020, 6, 4, 10, 10),
        data: {'gyro': 1, 'lin': 0, 'value': 100},
        notes: 'Description for activity.'),
    Activity(
        id: 'ninth',
        startTime: DateTime.utc(2020, 6, 4, 8, 10),
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

  void addActivity(String id, String notes, String type,
      Map<String, Object> data, DateTime startTime, DateTime endTime) {
    _activities.add(
      Activity(
        id: id,
        data: data,
        type: type,
        notes: notes,
        startTime: startTime,
        endTime: endTime,
      ),
    );
    notifyListeners();
  }
}
