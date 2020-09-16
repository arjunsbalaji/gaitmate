import 'package:flutter/foundation.dart';

class Activity with ChangeNotifier {
  final String id;
  final String notes;
  final String type;
  final Map<String, Object> data;
  final DateTime startTime;
  final DateTime endTime;

  Activity({
    @required this.id,
    @required this.data,
    @required this.notes,
    @required this.type,
    @required this.startTime,
    @required this.endTime,
  });
}
