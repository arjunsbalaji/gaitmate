import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/collections_preview.dart';
import '../providers/collection.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';
  @override
  Widget build(BuildContext context) {
    final Collection collection = Provider.of<Collection>(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                'Activities',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Center(
              child: Container(
                //color: Colors.red,
                padding: EdgeInsets.only(top: 10),
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      CollectionsPreview(collection.types[index]),
                  //itemBuilder: (context, index) =>
                  //    CollectionsPreview(collection[index]),
                  itemCount: collection.types.length,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
