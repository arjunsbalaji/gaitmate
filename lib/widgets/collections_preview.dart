import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaitmate/providers/collection.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../screens/activities_screen.dart';

class CollectionsPreview extends StatelessWidget {
  //final Collection collection;
  final String title;
  final User user;

  CollectionsPreview(this.title, this.user);

  @override
  Widget build(BuildContext context) {
    CollectionProvider collectionProvider =
        Provider.of<CollectionProvider>(context, listen: true);
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
              builder: (context) => ChangeNotifierProvider.value(
                value: collectionProvider,
                child: ActivitiesScreen(
                  title,
                  collectionProvider.user,
                ),
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
