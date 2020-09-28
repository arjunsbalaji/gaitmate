import 'package:flutter/material.dart';
import 'package:gaitmate/providers/collection.dart';
import 'package:provider/provider.dart';
import '../providers/activity.dart';

class ActivityScreen extends StatelessWidget {
  final Activity activity;

  ActivityScreen(this.activity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(activity.notes),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<Collection>(context, listen: false)
                        .removeActivity(activity.id);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
