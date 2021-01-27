import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:gaitmate/providers/activity.dart';

Duration strToDuration(String s) {
  int hours = 0;
  int minutes = 0;
  //int seconds = 0;
  int micros;
  if (s == '') {
    return Duration(hours: 0, minutes: 0, microseconds: 0);
  }

  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
  return Duration(hours: hours, minutes: minutes, microseconds: micros);
}

class CollectionProvider with ChangeNotifier {
  List<Activity> _activities = [];
  User user;
  CollectionProvider(this.user);
  final databaseReference = FirebaseDatabase.instance.reference();

  List<Activity> get activities {
    return _activities;
  }

  Future<void> initAndSetActivities(String atype) async {
    try {
      List<Activity> acts = [];
      DataSnapshot dataSnapshot =
          await databaseReference.child(user.uid).child('activities/').once();
      if (dataSnapshot.value != null) {
        dataSnapshot.value.forEach(
          (key, value) {
            Activity activity = createActivity(value);
            activity.setID(
                databaseReference.child(user.uid).child('activities/' + key));
            acts.add(activity);
          },
        );
      }

      _activities = acts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  DatabaseReference saveActivity(Activity activity) {
    var id = databaseReference.child(user.uid).child('activities/').push();
    id.set(activity.toJson());
    _activities.add(activity);
    notifyListeners();
    return id;
  }

  Future<void> removeActivity(DatabaseReference activityKey) async {
    await activityKey.remove();
    _activities.removeWhere(
      (Activity activity) => activity.id == activityKey,
    );
    notifyListeners();
  }

  Duration getActivitiesWeek(user, atype) {
    DateTime now = DateTime.now();
    Duration totalDur = Duration(seconds: 0);
    _activities.forEach(
      (Activity activity) {
        if (activity.endTime.isAfter(now.subtract(Duration(days: 7)))) {
          totalDur += activity.duration;
        }
      },
    );
    return totalDur;
  }
}
