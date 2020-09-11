import 'package:flutter/material.dart';
import '../models/collection_model.dart';
import '../screens/activities_screen.dart';

class CollectionsPreview extends StatelessWidget {
  final Collection collection;

  CollectionsPreview(this.collection);

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
          print(collection.title);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActivitiesScreen(
                collection,
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
            collection.title,
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
