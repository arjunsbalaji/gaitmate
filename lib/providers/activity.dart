import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gaitmate/providers/collection.dart';

class Activity with ChangeNotifier {
  DatabaseReference id;
  String notes;
  String type;
  List<List<int>> sensorData;
  Map<String, Object> data;
  DateTime startTime;
  Duration duration;
  DateTime endTime;
  Position position;

  Activity(
      {this.id,
      this.data,
      this.notes,
      this.type,
      this.sensorData,
      this.startTime,
      this.duration,
      this.endTime,
      this.position});

  void setID(DatabaseReference id) {
    this.id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'painRating': this.data['painRating'],
      'confidenceRating': this.data['confidenceRating'],
      'sensorData': this.sensorData,
      'notes': this.notes,
      'duration': this.duration.toString(),
      'startTime': this.startTime.toString(),
      'endTime': this.endTime.toString(),
      'type': this.type,
      'positionLatitude': this.position.latitude,
      'positionLongitude': this.position.longitude,
    };
  }
}

Activity createActivity(record) {
  Map<String, dynamic> attributes = {
    'data': {'painRating': 0, 'confidenceRating': 0},
    'notes': '',
    'duration': null,
    'sensorData': [],
    'startTime': null,
    'endTime': null,
    'type': '',
    'position': null,
  };

  record.forEach((key, value) => {attributes[key] = value});

  Activity activity = new Activity(
    data: {
      'painRating': attributes['painRating'],
      'confidenceRating': attributes['confidenceRating']
    },
    notes: attributes['notes'],
    sensorData: attributes['sensorData'],
    type: attributes['type'],
    startTime: DateTime.parse(attributes['startTime']),
    endTime: DateTime.parse(attributes['endTime']),
    duration: strToDuration(attributes['duration']),
    position: Position(
      latitude: attributes['positionLatitude'],
      longitude: attributes['positionLongitude'],
    ),
  );
  return activity;
}
