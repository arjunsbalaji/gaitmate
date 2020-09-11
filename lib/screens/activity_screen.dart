import 'package:flutter/material.dart';
import '../models/activity_model.dart';

class ActivityScreen extends StatelessWidget {
  final Activity activity;

  ActivityScreen(this.activity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Text(activity.id),
      ),
    );
  }
}
