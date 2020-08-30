import 'package:flutter/material.dart';
import 'package:gaitmate/models/collection_model.dart';

class CollectionListView extends StatelessWidget {
  final Collection collection;

  CollectionListView(this.collection);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 10, left: 10.0, right: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                collection.title,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              GestureDetector(
                onTap: () => print('See All'), //implement
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          //color: Colors.blue,
          height: 275.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, int index) {
              return Container(
                width: 210.0,
                //color: Colors.red,
                margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Container(
                      width: 210.0,
                      height: 130.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 6.0,
                                color: Colors.black26,
                                offset: Offset(0, 2))
                          ],
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Container(
                        margin: EdgeInsets.all(9.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
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
                                  fontSize: 22.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 15,
                      child: Container(
                        height: 150,
                        width: 175,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6.0,
                              color: Colors.black26,
                              offset: Offset(0, 2),
                            )
                          ],
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: [
                            Text(collection.activities[index].endTime
                                .toString()),
                            Text(collection.activities[index].startTime
                                .toString()),
                            Text(collection.activities[index].notes),
                            Text(collection.activities[index].value.toString()),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: collection.activities.length,
          ),
        )
      ],
    );
  }
}
