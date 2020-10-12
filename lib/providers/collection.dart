import 'dart:io';
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

  /* List<Activity> _activities = [
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
  ]; */

  List<Activity> _activities = [];
  final String authToken;
  final String userId;

  Collection(
    this.title,
    this.description,
    this.authToken,
    this.userId,
    this._activities,
  );

  List<Activity> get activities {
    return [..._activities];
  }

  List<Activity> getActvitiesByType(String type) {
    return _activities.where((act) => (act.type == type)).toList();
  }

  Future<void> initSetActivities() async {
    final url =
        'https://gaitmate.firebaseio.com/$userId/activities.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extData = json.decode(response.body) as Map<String, dynamic>;
      //print(extData.toString());
      final List<Activity> listActivities = [];
      extData.forEach(
        (id, data) {
          listActivities.add(
            Activity(
              id: id,
              data: data['data'],
              duration: data['duration'],
              endTime: DateTime.parse(data['endTime']),
              notes: data['notes'],
              startTime: DateTime.parse(data['startTime']),
              type: data['type'],
            ),
          );
        },
      );
      _activities = listActivities;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addActivity(Activity activity) async {
    final url =
        'https://gaitmate.firebaseio.com/$userId/activities.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'notes': activity.notes,
            'type': activity.type,
            'data': activity.data,
            'startTime': activity.startTime.toString(),
            'duration': activity.duration.toString(),
            'endTime': activity.endTime.toString(),
          },
        ),
      );
      final newActivity = Activity(
        id: json.decode(response.body)['name'],
        data: activity.data,
        type: activity.type,
        duration: activity.duration,
        notes: activity.notes,
        startTime: activity.startTime,
        endTime: activity.endTime,
      );
      _activities.add(newActivity);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> removeActivity(String id) async {
    final url =
        "https://gaitmate.firebaseio.com/$userId/activities/$id.json?auth=$authToken";
    final extActIndex = _activities.indexWhere((act) => act.id == id);
    var existingAct = _activities[extActIndex];
    _activities.removeAt(extActIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _activities.insert(extActIndex, existingAct);
      notifyListeners();
      throw HttpException('Could not delete this activity.');
    }
    existingAct = null;
  }
}
