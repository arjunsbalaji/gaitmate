import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Activity with ChangeNotifier {
  final String id;
  final String notes;
  final String type;
  final Map<String, Object> data;
  final DateTime startTime;
  final String duration;
  final Position position;
  final DateTime endTime;

  Activity({
    @required this.id,
    @required this.data,
    @required this.notes,
    @required this.type,
    @required this.startTime,
    @required this.duration,
    @required this.endTime,
    @required this.position,
  });
}
