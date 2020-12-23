import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../providers/collection.dart';
import '../providers/stopwatch.dart';
import '../providers/activity.dart';

class AddActvityForm extends StatefulWidget {
  @override
  _AddActvityFormState createState() => _AddActvityFormState();
}

class _AddActvityFormState extends State<AddActvityForm> {
  final _formKey = GlobalKey<FormState>();
  String dropType = 'run';
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final notesController = TextEditingController();

  Completer<GoogleMapController> _gMapsController = Completer();

  Activity _newActivity = Activity(
    id: null,
    data: null,
    notes: '',
    type: 'run',
    startTime: DateTime.now(),
    duration: '',
    endTime: DateTime.now().add(
      Duration(seconds: 100),
    ),
    position: null,
  );

  bool recording = false;
  bool submittable = false;
  bool isLoading = false;
  bool imageExists = false;
  Position _position;
  String _currentAddress;

  Future<void> _getPosition() async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
        .then((Position position) {
      setState(() {
        _position = position;
        //_newActivity.position = position;
      });
    }).catchError((e) {
      print(e);
    });
    placemarkFromCoordinates(_position.latitude, _position.longitude)
        .then((List<Placemark> placemark) {
      Placemark place = placemark[0];
      setState(() {
        _currentAddress =
            "${place.locality}"; //, ${place.postalCode}, ${place.country}";
      });
    }).catchError((e) {
      print(e);
    });
  }

  /*   CameraPosition _getCameraPosition(Position position) {
    return CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 20,
    );
  } */

  void _recordChange() {
    setState(
      () {
        recording = !recording;
      },
    );
  }

  Duration strToDuration(String s) {
    int hours = 0;
    int minutes = 0;
    //int seconds = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  void _reset(MyStopwatch swatch) {
    _formKey.currentState.reset();
    swatch.reset();
  }

  Future<void> _submit(MyStopwatch swatch) async {
    if (_formKey.currentState.validate()) {
      //IF I AM
      //RECORDING AND GO OFF THE PAGE TIMER ISNT CANCELLED
      //SO NEED TO PUT THAT IN
      //Strin g id = DateTime.now().millisecondsSinceEpoch.toString();
      setState(() {
        isLoading = true;
      });
      _formKey.currentState.save();
      //String notes = notesController.text;
      //Duration elapsedTime = Duration(seconds: swatch.counter);
      //DateTime startTime = DateTime.now();
      try {
        await Provider.of<Collection>(context, listen: false)
            .addActivity(_newActivity);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(dropType + ' Added!'),
            content: Text('Success!'),
            //can put actions here
          ),
        );
      }
      swatch.reset();
      setState(
        () {
          isLoading = false;
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _getPosition();
    MyStopwatch swatch = Provider.of<MyStopwatch>(context);
    return Form(
      key: _formKey,
      child: Container(
        //color: Colors.yellow,
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 10,
          top: 70,
        ),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _position != null
                      ? Container(
                          //color: Colors.red,
                          margin:
                              EdgeInsets.only(top: 20, left: 20, bottom: 20),
                          child: Text(
                            "You're in $_currentAddress today!",
                            style: TextStyle(fontSize: 22),
                          ),
                          /* GoogleMap(
                              mapType: MapType.hybrid,
                              initialCameraPosition:
                                  _getCameraPosition(_position),
                              onMapCreated:
                                  (GoogleMapController gMapsController) {
                                _gMapsController.complete(gMapsController);
                              },
                            ), */
                        )
                      : Container(
                          child: Text('No Location!'),
                        ),
                  Container(
                    padding: EdgeInsets.all(10),
                    //color: Colors.lime,
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F5F7),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6.0,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter some notes';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _newActivity = Activity(
                          notes: newValue,
                          id: _newActivity.id,
                          data: _newActivity.data,
                          duration: _newActivity.duration,
                          endTime: _newActivity.endTime,
                          startTime: _newActivity.startTime,
                          type: _newActivity.type,
                          position: _newActivity.position,
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        //color: Colors.purple,
                        alignment: Alignment.center,
                        child: DropdownButton<String>(
                          value: dropType,
                          icon: Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          underline: Container(
                            height: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              _newActivity = Activity(
                                  data: _newActivity.data,
                                  duration: _newActivity.duration,
                                  endTime: _newActivity.endTime,
                                  id: _newActivity.id,
                                  notes: _newActivity.notes,
                                  startTime: _newActivity.startTime,
                                  type: newValue,
                                  position: _position);
                              //print(dropType);
                            });
                          },
                          items: <String>['run', 'walk']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                    ],
                  ),
                  Container(
                    child: Text(
                      swatch.totalDuration,
                      style: TextStyle(
                        fontSize: 70.0,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.height * 0.1,
                    child: RaisedButton(
                      color: recording
                          ? Colors.redAccent
                          : Theme.of(context).primaryColor,
                      elevation: 10.0,
                      child: Container(
                        //color: Colors.blue,
                        width: MediaQuery.of(context).size.height * 0.05,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Expanded(
                          child: Column(
                            children: [
                              recording
                                  ? Icon(Icons.stop)
                                  : Icon(Icons.play_arrow),
                              recording ? Text('Stop') : Text('Start'),
                            ],
                          ),
                        ),
                      ),
                      shape: CircleBorder(
                        side: BorderSide(

                            //color: Theme.of(context).primaryColor,
                            ),
                      ),
                      onPressed: () {
                        _recordChange();
                        recording ? swatch.start() : swatch.pause();
                        submittable = true;
                        //print(recording);
                        //print(_position.latitude.toString());
                        //print(_currentAddress);
                        //print("recording...");
                      },
                    ),
                  ),
                  (submittable && !recording)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                              child: Text('Reset'),
                              onPressed: () => _reset(swatch),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            RaisedButton(
                              child: Text('Submit'),
                              onPressed: () => _submit(swatch),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 80,
                          width: 10,
                        ),
                ],
              ),
      ),
    );
  }
}
