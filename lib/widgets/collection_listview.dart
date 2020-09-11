import 'package:flutter/material.dart';
import '../models/collection_model.dart';
import 'package:intl/intl.dart';
import '../screens/activity_screen.dart';

class CollectionListView extends StatelessWidget {
  final Collection collection;
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  CollectionListView(this.collection);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 30, left: 10.0, right: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  collection.title,
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            //color: Colors.blue,
            //height: (MediaQuery.of(context).size.height) * 0.8,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, int index) {
                return GestureDetector(
                  onTap: () {
                    print(collection.activities[index].id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityScreen(
                          collection.activities[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    //color: Colors.red,
                    margin:
                        EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                    child: Container(
                      height: 100.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 6.0,
                                color: Colors.black26,
                                offset: Offset(0, 2))
                          ],
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(9.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  collection.activities[index].id,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2,
                                      fontSize: 22.0),
                                ),
                                Text(
                                  collection.activities[index].notes,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2,
                                      fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              //color: Colors.red,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(formatter.format(
                                      collection.activities[index].startTime)),
                                  Text(collection.activities[index].value
                                      .toString()),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: collection.activities.length,
            ),
          ),
        )
      ],
    );
  }
}
