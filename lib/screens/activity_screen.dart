import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaitmate/providers/collection.dart';
import 'package:provider/provider.dart';
import '../providers/activity.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActivityScreen extends StatelessWidget {
  final Activity activity;

  Completer<GoogleMapController> _gMapsController = Completer();
  ActivityScreen(this.activity);

  CameraPosition _getCameraPosition(Position position) {
    return CameraPosition(
      target: LatLng(activity.position.latitude, activity.position.longitude),
      zoom: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    print(activity.position.toString());
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(activity.notes),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<Collection>(context, listen: false)
                        .removeActivity(activity.id);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            Text(
                "${activity.position.latitude},${activity.position.longitude}"),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.only(top: 20, bottom: 20),
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
                  initialCameraPosition: _getCameraPosition(activity.position),
                  onMapCreated: (GoogleMapController gMapsController) {
                    _gMapsController.complete(gMapsController);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
