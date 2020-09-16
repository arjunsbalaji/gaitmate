import 'package:flutter/material.dart';
import 'package:gaitmate/providers/activity.dart';
import '../providers/collection.dart';
import '../screens/activities_screen.dart';
import 'package:provider/provider.dart';

class CollectionsPreview extends StatelessWidget {
  //final Collection collection;
  final String title;

  CollectionsPreview(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      width: (MediaQuery.of(context).size.width - 20) *
          0.5, //20 comes from edgeinsets all 10 on dashboard screen
      //color: Colors.green,
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          print(title);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActivitiesScreen(
                title,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 6.0,
                color: Colors.black26,
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
