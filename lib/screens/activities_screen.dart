import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaitmate/providers/activity.dart';
import '../widgets/collection_listview.dart';

class ActivitiesScreen extends StatefulWidget {
  static const routeName = '/activities';

  //final List<Activity> actvities;
  final String title;
  final User user;

  ActivitiesScreen(this.title, this.user);

  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState(title, user);
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {

  final String title;
  final User user;

  _ActivitiesScreenState(this.title, this.user);

  List<Activity> activities = [];
  
  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(15.0),
        child: CollectionListView(widget.title, user),
      ),
    );
  }
}
