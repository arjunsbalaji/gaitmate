import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaitmate/Services/database.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/stopwatch.dart';
import '../providers/activity.dart';
import 'package:gaitmate/widgets/leftFootMap.dart';
import 'package:gaitmate/widgets/rightFootMap.dart';

class AddActivityForm extends StatefulWidget {
  final User user;
  AddActivityForm(this.user);

  @override
  _AddActivityFormState createState() => _AddActivityFormState();
}

class _AddActivityFormState extends State<AddActivityForm> {
  final _formKey = GlobalKey<FormState>();
  String dropType = 'run';
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final notesController = TextEditingController();

  Activity _newActivity = Activity(
    id: null,
    data: {'painRating': 0, 'confidenceRating': 0},
    notes: '',
    type: 'run',
    startTime: DateTime.now(),
    duration: Duration(seconds: 0),
    endTime: (DateTime.now().add(
      Duration(seconds: 1))),
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
    var status = await Permission.location.status;
    print (status);
    if (status != PermissionStatus.granted) {
      await Permission.location.request();
    }
    if (status == PermissionStatus.granted) {
      try {
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
            .then((Position position) {
          setState(() {
            _position = position;
          });
          _getAddress(_position);
        }).catchError((e) {
          print(e);
        });
      } on Exception catch (_) {}
    }
    else {
      setState(() {
        _position = Position(latitude: -32.01088385372162, longitude: 115.81459351402168);
      });
    }
    
  }

  void _getAddress(Position position) {
    placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemark) {
      Placemark place = placemark[0];
      setState(() {
        //print(place.toString());
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
      saveActivity(widget.user, _newActivity);
      swatch.reset();
      setState(() {
        isLoading = false;
      });
      FocusScope.of(context).unfocus();
      Navigator.pop(context, 'added');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_position == null) {_getPosition();}
    //print(_position.toString());
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
            : SingleChildScrollView(
                child: Column (
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _position != null
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top:10, left:10, bottom:10
                          ),
                          child: Text(
                            "You're in $_currentAddress today!",
                            style: TextStyle(fontSize:20),
                          )
                        )
                      ],
                    )
                    : Container(
                      child: Text('No Location!'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LeftFootMap(),
                        RightFootMap(),
                      ],
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
                          labelText: 'Notes about your activity ...',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter some notes';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _newActivity.endTime = DateTime.now();
                          _newActivity.duration = _newActivity.endTime.difference(_newActivity.startTime);
                          _newActivity.notes = newValue;
                          if (_position != null) {_newActivity.position = _position;}
                          else
                          {
                            _newActivity.position = Position(latitude: -32.01088385372162, longitude: 115.81459351402168);
                          }
                        },
                      ),
                    ),
                    SizedBox(height:MediaQuery.of(context).size.height*0.05),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            'Pain Rating',
                            style: TextStyle(fontSize:16),
                            textAlign: TextAlign.start,
                          ),
                          Slider(
                            value:_painRating,
                            max:10,
                            min:0,
                            label: _painRating.toString(),
                            onChanged: (double value) {
                              setState(() {
                                _newActivity.data['painRating'] = value;
                                _painRating = value;
                              });
                            }),
                      ],),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            'Confidence during activity',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.start,
                          ),
                          Slider(
                            value: _confidenceRating,
                            max: 10,
                            min: 0,
                            label: _confidenceRating.toString(),
                            onChanged: (double value) {
                              setState(() {
                                _newActivity.data['confidenceRating'] = 
                                value;
                                _confidenceRating = value;
                              });
                            }
                          )
                        ],)
                    ),
                    Container(
                      child: Text(
                        swatch.totalDuration,
                        style: TextStyle(
                          fontSize: 50.0,
                        ),
                      ),
                    ),
                    (!submittable || recording)
                    ? Container(
                        margin: EdgeInsets.only(top: 10),
                        height: MediaQuery.of(context).size.height*0.1,
                        width: MediaQuery.of(context).size.height*0.1,
                        child: RaisedButton(
                          color: recording
                              ? Colors.redAccent
                              : Theme.of(context).primaryColor,
                          elevation: 10.0,
                          child: Container(
                            //color: Colors.blue,
                            height: MediaQuery.of(context).size.height*0.06,
                            width: MediaQuery.of(context).size.height*0.06,
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
                          },
                        ),
                      )
                    : SizedBox(
                      height: MediaQuery.of(context).size.height*0.05,
                      width:10,
                    ),
                    (submittable && !recording)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                child: Text('Reset'),
                                onPressed: () {
                                  submittable = false;
                                  _reset(swatch);
                                }
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.1,
                                height: MediaQuery.of(context).size.height*0.1,
                              ),
                              RaisedButton(
                                child: Text('Submit'),
                                onPressed: () => _submit(swatch),
                              ),
                            ],
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height*0.1,
                            width: 10,
                          ),
                  ],
                ),
            ),
      ),
    );
  }
}
