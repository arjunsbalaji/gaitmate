import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gaitmate/Services/database.dart';
import '../providers/activity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gaitmate/widgets/columnChartWidget.dart';
import 'package:gaitmate/widgets/sensor_data_chart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActivityScreen extends StatelessWidget {
  final Activity activity;
  final User user;
  final int index;

  final Completer<GoogleMapController> _gMapsController = Completer();
  ActivityScreen(this.user, this.activity, this.index);

  CameraPosition _getCameraPosition(Position position) {
    return CameraPosition(
      target: LatLng(activity.position.latitude, activity.position.longitude),
      zoom: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    //print(activity.position.toString());
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${DateFormat.yMMMd('en_US').format(activity.startTime)} #${index + 1}",
                      style: TextStyle(fontSize: 34),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      removeActivity(activity.id);
                      Navigator.pop(context, 'deleted');
                    },
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.only(top: 20, bottom: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6.0,
                      color: Colors.black26,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GoogleMap(
                    mapType: MapType.hybrid,
                    initialCameraPosition:
                        _getCameraPosition(activity.position),
                    onMapCreated: (GoogleMapController gMapsController) {
                      _gMapsController.complete(gMapsController);
                    },
                  ),
                ),
              ),
              SensorDataChart(activity.sensorData),
              Container(
                child: Text(
                  "Activity Time: ${activity.duration.inMinutes} mins ${activity.duration.inSeconds} secs",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.left,
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  activity.notes,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  'Pain - ${(double.parse((activity.data['painRating']).toString())).toStringAsFixed(1)}/10',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  'Confidence - ${(double.parse((activity.data['confidenceRating']).toString())).toStringAsFixed(1)}/10',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: ColumnChart()),
            ],
          ),
        ),
      ),
    );
  }
}
