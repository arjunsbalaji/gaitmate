import 'package:flutter/material.dart';
import './activity_model.dart';

class Collection {
  String title;
  String description;
  List<Activity> activities;

  Collection({
    @required this.title,
    @required this.description,
    @required this.activities,
  });
}

List<Activity> activities = [
  Activity(
      id: 'first',
      startTime: DateTime.utc(2020, 6, 4, 8, 10),
      endTime: DateTime.utc(2020, 6, 4, 10, 10),
      value: 0,
      notes: 'Description for activity.'),
  Activity(
      id: 'second',
      startTime: DateTime.utc(2020, 6, 4, 8, 10),
      endTime: DateTime.utc(2020, 6, 4, 10, 10),
      value: 0,
      notes: 'Description for activity.'),
  Activity(
      id: 'third',
      startTime: DateTime.utc(2020, 6, 4, 8, 10),
      endTime: DateTime.utc(2020, 6, 4, 10, 10),
      value: 0,
      notes: 'Description for activity.'),
  Activity(
      id: 'fourth',
      startTime: DateTime.utc(2020, 6, 4, 8, 10),
      endTime: DateTime.utc(2020, 6, 4, 10, 10),
      value: 0,
      notes: 'Description for activity.'),
  Activity(
      id: 'fifth',
      startTime: DateTime.utc(2020, 6, 4, 8, 10),
      endTime: DateTime.utc(2020, 6, 4, 10, 10),
      value: 0,
      notes: 'Description for activity.'),
];

List<Collection> collections = [
  Collection(
    title: 'Runs',
    activities: activities,
    description: 'Go for a run.',
  ),
  Collection(
    title: 'Walks',
    activities: activities,
    description: 'Go for a run.',
  )
];
