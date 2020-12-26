import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../providers/collection.dart';
import '../providers/stopwatch.dart';
import '../providers/activity.dart';
import '../providers/acitivty_type_enum.dart';

class AddActvityForm extends StatefulWidget {
  @override
  _AddActvityFormState createState() => _AddActvityFormState();
}

class _AddActvityFormState extends State<AddActvityForm> {
  final _formKey = GlobalKey<FormState>();
  ActivityType selectedType = ActivityType.walk;
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final notesController = TextEditingController();

  Activity _newActivity = Activity(
    id: null,
    data: {},
    notes: '',
    type: 'run',
    startTime: DateTime.now(),
    duration: Duration(seconds: 0),
    endTime: DateTime.now().add(
      Duration(seconds: 1),
    ),
    position: null,
  );

  bool recording = false;
  bool submittable = false;
  bool isLoading = false;
  bool imageExists = false;
  Position _position;
  String _currentAddress;
  double _painRating = 0;
  double _confidenceRating = 0;

  Future<void> _getPosition() async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
        .then((Position position) {
      setState(() {
        _position = position;
        //print(_position.toString());
        //_newActivity.position = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  void _getAddress(Position position) {
    placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemark) {
      Placemark place = placemark[0];
      setState(() {
        print(place.toString());
        _currentAddress =
            "${place.locality}"; //, ${place.postalCode}, ${place.country}";
      });
    }).catchError((e) {
      print(e);
    });
  }

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

  Position strToPosition(String s) {
    List<String> numbers = s.split(',');
    double lat = double.parse(s.substring(-1, -13));
    print(lat.toString());
  }

  void _reset(MyStopwatch swatch) {
    _formKey.currentState.reset();
    swatch.reset();
  }

  Future<void> _submit(BuildContext context, MyStopwatch swatch) async {
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
          builder: (_) => AlertDialog(
            title: Text(selectedType.toString() + ' Added!'),
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
    (_position is Position) ? print('hello') : _getPosition();
    _getAddress(_position);
    print(_position.toString());
    MyStopwatch swatch = Provider.of<MyStopwatch>(context);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
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
              : Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _position != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  //color: Colors.red,
                                  margin: EdgeInsets.only(
                                      top: 20, left: 10, bottom: 20),
                                  child: Text(
                                    "You're in $_currentAddress today!",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                              ],
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
                            labelText: 'Notes about your activity...',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter some notes';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _newActivity.endTime
                                .difference(_newActivity.startTime)
                                .toString();
                            _newActivity = Activity(
                              notes: newValue,
                              id: _newActivity.id,
                              data: _newActivity.data,
                              duration: _newActivity.endTime
                                  .difference(_newActivity.startTime),
                              endTime: _newActivity.endTime,
                              startTime: _newActivity.startTime,
                              type: selectedType.toString().split('.')[1],
                              position: _position,
                            );
                          },
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: RadioListTile<ActivityType>(
                                subtitle: Text('Walk'),
                                value: ActivityType.walk,
                                groupValue: selectedType,
                                onChanged: (ActivityType value) {
                                  setState(() {
                                    selectedType = value;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<ActivityType>(
                                subtitle: Text('Run'),
                                value: ActivityType.run,
                                groupValue: selectedType,
                                onChanged: (ActivityType value) {
                                  setState(() {
                                    selectedType = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        //color: Colors.blue,
                        child: Column(
                          children: [
                            Text(
                              'Pain Rating',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.start,
                            ),
                            Slider(
                                value: _painRating,
                                max: 10,
                                min: 0,
                                label: _painRating.toString(),
                                onChanged: (double value) {
                                  setState(() {
                                    //print(value);
                                    _newActivity.data['painRating'] = value;
                                    _painRating = value;
                                  });
                                }),
                          ],
                        ),
                      ),
                      Container(
                        //color: Colors.blue,
                        child: Column(
                          children: [
                            Text(
                              'Confidence during activity',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.start,
                            ),
                            Slider(
                                value: _confidenceRating,
                                max: 10,
                                min: 0,
                                label: _confidenceRating.toString(),
                                onChanged: (double value) {
                                  setState(() {
                                    //print(value);
                                    //print(_newActivity.data.toString());
                                    _newActivity.data['confidenceRating'] =
                                        value;
                                    _confidenceRating = value;
                                  });
                                }),
                          ],
                        ),
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
                            child: Column(
                              children: [
                                recording
                                    ? Icon(Icons.stop)
                                    : Icon(Icons.play_arrow),
                                recording ? Text('Stop') : Text('Start'),
                              ],
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                ),
                                RaisedButton(
                                  child: Text('Submit'),
                                  onPressed: () => _submit(context, swatch),
                                ),
                              ],
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: 10,
                            ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
