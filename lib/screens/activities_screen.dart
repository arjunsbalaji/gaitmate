import 'package:flutter/material.dart';
import '../widgets/collection_listview.dart';
import '../models/collection_model.dart';

class ActivitiesScreen extends StatelessWidget {
  static const routeName = '/activities';

  final Collection collection;

  ActivitiesScreen(this.collection);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(15.0),
        child: CollectionListView(collection),
      ),
    );
  }
}
