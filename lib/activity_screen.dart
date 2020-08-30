import 'package:flutter/material.dart';
import './widgets/collection_listview.dart';
import './models/collection_model.dart';

class ActivityScreen extends StatelessWidget {
  static const routeName = '/activity';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              CollectionListView(collections[0]),
              CollectionListView(collections[1]),
            ],
          )),
    );
  }
}
