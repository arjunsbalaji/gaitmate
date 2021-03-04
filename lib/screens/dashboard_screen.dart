import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaitmate/providers/activity.dart';
import 'package:gaitmate/providers/collection.dart';
import 'package:gaitmate/screens/add_activity_screen.dart';
import 'package:gaitmate/widgets/collections_preview.dart';
import 'package:gaitmate/Services/database.dart';
import 'package:gaitmate/widgets/painGraph.dart';
import 'package:gaitmate/widgets/quote.dart';
import 'package:gaitmate/widgets/totalDurationText.dart';

class DashboardScreen extends StatefulWidget {
  final User user;

  DashboardScreen(this.user);
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Duration totalDuration;
  final activitytypes = ['Runs', 'Walks'];
  String strTotalDuration;
  List<int> pain;

  void getActivitiesDuration() {
    getActivitiesWeekDuration(widget.user, 'all').then(
      (totalDuration) => {
        this.setState(
          () {
            this.totalDuration = totalDuration;
            this.strTotalDuration =
                totalDuration.toString().split('.').first.padLeft(8, '0');
          },
        )
      },
    );
  }

  void getActivitiesPain() {
    getActivitiesWeekPain(widget.user, 'all').then(
      (pain) => {
        this.setState(
          () {
            this.pain = pain;
          },
        )
      },
    );
  }

  void initState() {
    super.initState();
    getActivitiesPain();
    getActivitiesDuration();
  }

  @override
  Widget build(BuildContext context) {
    //CollectionProvider collection = Provider.of<CollectionProvider>(context);

    List cardList = [
      Quote(),
      PainChart(this.pain),
      TotalDurationText(strTotalDuration),
    ];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          _navigatorAndReload(context);
        },
      ),
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
                      CollectionsPreview(activitytypes[index], widget.user),
                  itemCount: activitytypes.length,
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
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03),
            Center(
              child: pain == null
              ? Column(children:[SizedBox(height:MediaQuery.of(context).size.height * 0.1),
                                CircularProgressIndicator()])
              : CarouselSlider(
                items: cardList.map((card) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height*0.25,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Card(
                              child: card,
                          ),
                        )
                      );
                    }
                    );
                }).toList(),
                options: CarouselOptions(height: MediaQuery.of(context).size.height*0.25),

              )
            ), 

          ],
        ),
      ),
    );
  }

  _navigatorAndReload(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddActivityScreen(
          widget.user,
        ),
      ),
    );
    /* 
    if (result == 'added') {
      setState(
        () {
          getActivities();
        },
      );
    } */
  }
}
