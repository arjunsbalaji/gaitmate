import 'package:firebase_database/firebase_database.dart';
import 'package:gaitmate/providers/activity.dart';
import 'package:gaitmate/providers/userDetails.dart';

final databaseReference = FirebaseDatabase.instance.reference();

void removeActivity(activityKey) async {
  await activityKey.remove();
}

Future<List<Activity>> getActivitiesByType(user, atype) async {
  List<Activity> activities = [];
  DataSnapshot dataSnapshot =
      await databaseReference.child(user.uid).child('activities/').once();
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      Activity activity = createActivity(value);
      activity
          .setID(databaseReference.child(user.uid).child('activities/' + key));
      activities.add(activity);
    });
  }
  return activities;
}

DatabaseReference saveActivity(user, activity) {
  var id = databaseReference.child(user.uid).child('activities/').push();
  id.set(activity.toJson());
  return id;
}

Future<UserDetails> findUserDetails(user) async {
  DataSnapshot dataSnapshot =
      await databaseReference.child(user.uid).child('userDetails/').once();
  if (dataSnapshot.value != null) {
    UserDetails userdetails = getUserDetails(dataSnapshot.value);
    return userdetails;
  } else {
    return new UserDetails();
  }
}

void updateDetails(user, userDetails) {
  databaseReference
      .child(user.uid)
      .child('userDetails/')
      .update(userDetails.toJson());
}

Future<Duration> getActivitiesWeekDuration(user, atype) async {
  final now = DateTime.now();
  Duration totalDuration = Duration(seconds: 0);

  List<Activity> activities = [];
  DataSnapshot dataSnapshot =
      await databaseReference.child(user.uid).child('activities/').once();
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      Activity activity = createActivity(value);
      activity
          .setID(databaseReference.child(user.uid).child('activities/' + key));
      if (activity.startTime
          .isAfter(DateTime(now.year, now.month, now.day - 7))) {
        activities.add(activity);
        totalDuration += Duration(
          hours:activity.duration.inHours,
          minutes:activity.duration.inMinutes.remainder(60),
          seconds:activity.duration.inSeconds.remainder(60));
      }
    });
  }
  return totalDuration;
}

Future<List<int>> getActivitiesWeekPain(user, atype) async {
  final now = DateTime.now();
  List<int> pain = [];

  List<Activity> activities = [];
  DataSnapshot dataSnapshot =
      await databaseReference.child(user.uid).child('activities/').once();
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      Activity activity = createActivity(value);
      activity
          .setID(databaseReference.child(user.uid).child('activities/' + key));
      if (activity.startTime
          .isAfter(DateTime(now.year, now.month, now.day - 7))) {
        activities.add(activity);
        pain.add(activity.data['painRating']);
      }
    });
  }
  return pain;
}