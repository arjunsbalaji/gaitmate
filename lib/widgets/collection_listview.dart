import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaitmate/providers/collection.dart';
import 'package:provider/provider.dart';
import '../providers/activity.dart';
import '../screens/activity_screen.dart';
import 'package:gaitmate/Services/database.dart';
import 'package:intl/intl.dart';

class CollectionListView extends StatefulWidget {
  final String title;
  final User user;

  CollectionListView(this.title, this.user);
  _CollectionListViewState createState() =>
      _CollectionListViewState(title, user);
}

class _CollectionListViewState extends State<CollectionListView> {
  final String title;
  final User user;
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  bool loaded = false;
  bool sortEarlyLate = true;

  _CollectionListViewState(this.title, this.user);

  // List<Activity> activities = [];
/* 
  void getActivities(List<Activity> activities) {
    final String type = title == 'Runs' ? 'run' : 'walk';
    getActivitiesByType(user, type).then((activities) => {
          this.setState(() {
            activities = activities;
          })
        });
  }
 */
  @override
  void didChangeDependencies() {
    //put new null safety here
    //print('initttttt');
    if (!loaded) {
      Provider.of<CollectionProvider>(context).initAndSetActivities('runs');
      loaded = true;
    }
    //print('post if');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final activities =
        Provider.of<CollectionProvider>(context, listen: true).activities;
    if (sortEarlyLate == true)
      {activities.sort((a,b) => a.startTime.compareTo(b.startTime));}
    else
      {activities.sort((a,b) => b.startTime.compareTo(a.startTime));}

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 40, left: 10.0, right: 10.0, bottom: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 38.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.sort),
                onPressed: () {
                  if (sortEarlyLate == true) {
                    setState(() {
                      sortEarlyLate = false;
                    });
                  }
                  else {
                    setState(() {
                      sortEarlyLate = true;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: activities.isEmpty
              ? Center(child: CircularProgressIndicator()) //implementation for provider null
              : Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, int index) {
                      return GestureDetector(
                        onTap: () {
                          _navigatorAndReload(context, index);
                        },
                        child: Container(
                          //color: Colors.red,
                          margin: EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 10.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.15,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${DateFormat.yMMMd('en_US').format(activities[index].startTime)} #${index}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.2,
                                            fontSize: 22.0),
                                      ),
                                      Expanded(
                                        child: ShaderMask(
                                          shaderCallback: (rect) {
                                            return LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.black,
                                                Colors.transparent
                                              ],
                                            ).createShader(
                                              Rect.fromLTRB(0, 0, rect.width,
                                                  rect.height),
                                            );
                                          },
                                          blendMode: BlendMode.dstIn,
                                          child: Container(
                                            margin: EdgeInsets.only(top: 5),
                                            //color: Colors.red,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: Text(
                                              activities[index].notes,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.2,
                                                  fontSize: 14.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    //color: Colors.green,
                                    child: Text(
                                      "${activities[index].duration.inMinutes.remainder(60)}m ${activities[index].duration.inSeconds.remainder(60)}s",
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: activities.length,
                  ),
                ),
        )
      ],
    );
  }

  _navigatorAndReload(BuildContext context, int index) {
    CollectionProvider collectionProvider =
        Provider.of<CollectionProvider>(context, listen: false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: collectionProvider,
          child: ActivityScreen(
            collectionProvider.user,
            collectionProvider.activities[index],
            index,
          ),
        ),
      ),
    );
  }
}
