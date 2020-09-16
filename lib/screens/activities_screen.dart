import 'package:flutter/material.dart';
import 'package:gaitmate/providers/activity.dart';
import 'package:gaitmate/providers/collection.dart';
import 'package:provider/provider.dart';
import '../widgets/collection_listview.dart';

class ActivitiesScreen extends StatelessWidget {
  static const routeName = '/activities';

  //final List<Activity> actvities;
  final String title;

  ActivitiesScreen(this.title);

  @override
  Widget build(BuildContext context) {
    final String type = title == 'Runs' ? 'run' : 'walk';
    //need to make this cleaner above
    final List<Activity> activities =
        Provider.of<Collection>(context).getActvitiesByType(type);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(15.0),
        child: CollectionListView(title, activities),
      ),
    );
  }
}
