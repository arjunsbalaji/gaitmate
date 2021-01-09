import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:gaitmate/Services/database.dart';
import 'package:gaitmate/providers/blue_provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    sensorData: [],
    data: {'painRating': 0, 'confidenceRating': 0},
    notes: '',
    type: 'run',
    startTime: DateTime.now(),
    duration: Duration(seconds: 0),
    endTime: (DateTime.now().add(Duration(seconds: 1))),
    position: null,
  );

  List<List<int>> sensorData = [];

  StreamController<List<int>> streamController;
  StreamSubscription<List<int>> streamSubscription;
  //StreamSubscription<String> streamSubscription;

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
    print(status);
    if (status != PermissionStatus.granted) {
      await Permission.location.request();
    }
    if (status == PermissionStatus.granted) {
      try {
        await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.low)
            .then((Position position) {
          setState(() {
            _position = position;
          });
          _getAddress(_position);
        }).catchError((e) {
          print(e);
        });
      } on Exception catch (_) {}
    } else {
      setState(() {
        _position = Position(
            latitude: -32.01088385372162, longitude: 115.81459351402168);
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

  /*  void sensorData(BlueProvider blue) async {
    blue.getCharacteristic();
    blue.listenSensorData();
  } */

  Future<void> _submit(MyStopwatch swatch, List<List<int>> sensorData) async {
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
      Duration elapsedTime = Duration(seconds: swatch.counter);
      //DateTime startTime = DateTime.now();
      _newActivity.duration = elapsedTime;
      _newActivity.sensorData = sensorData;
      saveActivity(widget.user, _newActivity);
      swatch.reset();
      setState(() {
        isLoading = false;
      });
      FocusScope.of(context).unfocus();
      Navigator.pop(context, 'added');
    }
  }

/* 
  Widget showForcePlot4p() {
    return 
  } */

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_position == null) {
      _getPosition();
    }

    BlueProvider blue = Provider.of<BlueProvider>(context, listen: true);

    MyStopwatch swatch = Provider.of<MyStopwatch>(context);

    //blue.updateBluetoothStatus();
    //blue.getCharacteristic();
    //print('CHAR ' + blue.characteristic.toString());
    //print('DEVICE' + blue.device.toString());
    //print(blue.status.toString());

    if (blue.device == null) {
      blue.connectDevice();
      print('ADD ACT PAGEd' + '${blue.device}');
      blue.getCharacteristic();
      print('ADD ACT PAGEcm' + '${blue.characteristic}');
      if (blue.characteristic != null) {
        blue.getSensorDataStream();
        print(blue.sensorStream.toString());
        //Stream<List<int>> stream = blue.getSensorDataStream();
        //print(stream.toString());
        //streamController =
        /* streamSubscription = blue.sensorStream
            .asBroadcastStream()
            .listen((List<int> event) => print(event)); */
      }
    }

    //if (device !){streamController.addStream(blue.getSensorDataStream());}

    return Scaffold(
      appBar: AppBar(
        title: Text('Add an Activity '),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          //color: Colors.yellow,
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 10,
            top: 20,
          ),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _position != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 30, left: 10, bottom: 10),
                                  child: Text(
                                    "You're in $_currentAddress today!",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    icon: Icon(Icons.bluetooth),
                                    onPressed: () {
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Bluetooth Status'),
                                            content: Container(
                                              child: StreamBuilder<
                                                  BluetoothDeviceState>(
                                                stream: blue.deviceState,
                                                initialData:
                                                    BluetoothDeviceState
                                                        .disconnected,
                                                builder: (context, snapshot) {
                                                  /* if (snapshot.data ==
                                                      BluetoothDeviceState
                                                          .connected) {
                                                    //put switch case here for on, available, scanning, connected lights
                                                    return Container(
                                                        color: Colors.green,
                                                        height: 20,
                                                        width: 20);
                                                  } else {
                                                    return Container(
                                                        color: Colors.red,
                                                        height: 20,
                                                        width: 20);
                                                  }, */

                                                  /*  blue.device == null
                                          ? print('no device')
                                          :  */ /* 
                                          snapshot.data == null ?
                                          print('no device')
                                                   */

                                                  switch (snapshot.data) {
                                                    case BluetoothDeviceState
                                                        .connected:
                                                      {
                                                        return Container(
                                                            color: Colors.green,
                                                            height: 20,
                                                            width: 20);
                                                      }
                                                      break;
                                                    case BluetoothDeviceState
                                                        .connecting:
                                                      {
                                                        return Container(
                                                            color: Colors.amber,
                                                            height: 20,
                                                            width: 20);
                                                      }
                                                      break;
                                                    case BluetoothDeviceState
                                                        .disconnected:
                                                      {
                                                        return Container(
                                                            color: Colors.red,
                                                            height: 20,
                                                            width: 20);
                                                      }
                                                      break;
                                                    case BluetoothDeviceState
                                                        .disconnecting:
                                                      {
                                                        return Container(
                                                            color: Colors.red,
                                                            height: 20,
                                                            width: 20);
                                                      }
                                                      break;
                                                  }
                                                },
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Scan and Connect'),
                                                onPressed: () {
                                                  //BluetoothDeviceState ds = await blue.deviceState;
                                                  if (blue.device == null) {
                                                    blue.connectDevice();
                                                    print(
                                                        blue.status.toString());
                                                  } else {
                                                    throw Exception(
                                                        'connected to device already!');
                                                  }
                                                },
                                              ),
                                              TextButton(
                                                child: Text('Disconnect'),
                                                onPressed: () {
                                                  blue.device.disconnect();
                                                  print(blue.device.id
                                                      .toString());
                                                  print(blue.status.toString());
                                                },
                                              ),
                                              TextButton(
                                                child: Text('Dismiss'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              child: Text('No Location!'),
                            ),
                      StreamBuilder<BluetoothDeviceState>(
                          stream: blue.deviceState,
                          builder: (context, snapshot) {
                            switch (snapshot.data) {
                              case BluetoothDeviceState.connected:
                                {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LeftFootMap(),
                                      RightFootMap(), //streamController.stream),
                                    ],
                                  );
                                }
                                break;
                              case BluetoothDeviceState.connecting:
                                {
                                  return Container(
                                      color: Colors.amber,
                                      height: 20,
                                      width: 20);
                                }
                                break;
                              case BluetoothDeviceState.disconnected:
                                {
                                  return Container(
                                      color: Colors.red, height: 20, width: 20);
                                }
                                break;
                              case BluetoothDeviceState.disconnecting:
                                {
                                  return Container(
                                      color: Colors.red, height: 20, width: 20);
                                }
                                break;
                            }
                            /* Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LeftFootMap(),
                                RightFootMap(), //streamController.stream),
                              ],
                            ); */
                          }),
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
                            _newActivity.duration = _newActivity.endTime
                                .difference(_newActivity.startTime);
                            _newActivity.notes = newValue;
                            if (_position != null) {
                              _newActivity.position = _position;
                            } else {
                              _newActivity.position = Position(
                                  latitude: -32.01088385372162,
                                  longitude: 115.81459351402168);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Container(
                        child: Column(
                          children: [
                            Text(
                              'Pain Rating',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.start,
                            ),
                            Slider(
                                value: _painRating,
                                max: 10,
                                min: 0,
                                label: _painRating.toString(),
                                onChanged: (double value) {
                                  setState(() {
                                    _newActivity.data['painRating'] = value;
                                    _painRating = value;
                                  });
                                }),
                          ],
                        ),
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
                                  _newActivity.data['confidenceRating'] = value;
                                  _confidenceRating = value;
                                });
                              })
                        ],
                      )),
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
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.height * 0.1,
                              child: blue.device == null
                                  ? Text('No Device Connected!')
                                  : RaisedButton(
                                      color: recording
                                          ? Colors.redAccent
                                          : Theme.of(context).primaryColor,
                                      elevation: 10.0,
                                      child: StreamBuilder<
                                              BluetoothDeviceState>(
                                          stream: blue.deviceState,
                                          initialData:
                                              BluetoothDeviceState.disconnected,
                                          builder: (context, snapshot) {
                                            if (snapshot.data !=
                                                BluetoothDeviceState
                                                    .connected) {
                                              return Text(
                                                  'No Device Connected!');
                                            } else {
                                              return Container(
                                                //color: Colors.blue,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.06,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.06,
                                                child: Column(
                                                  children: [
                                                    recording
                                                        ? Icon(Icons.stop)
                                                        : Icon(
                                                            Icons.play_arrow),
                                                    recording
                                                        ? Text('Stop')
                                                        : Text('Start'),
                                                  ],
                                                ),
                                              );
                                            }
                                          }),
                                      shape: CircleBorder(
                                        side: BorderSide(
                                            //color: Theme.of(context).primaryColor,
                                            ),
                                      ),
                                      onPressed: () async {
                                        _recordChange();
                                        if (blue.characteristic == null) {
                                          await blue.getCharacteristic();
                                        }
                                        switch (recording) {
                                          case true:
                                            {
                                              swatch.start();
                                              await blue.characteristic
                                                  .setNotifyValue(true);
                                              streamSubscription = blue
                                                  .sensorStream
                                                  .asBroadcastStream()
                                                  .listen((List<int> event) {
                                                print(event.toString());
                                                sensorData.add(event);
                                              });
                                              //streamSubscription.resume();
                                            }
                                            break;
                                          case false:
                                            {
                                              swatch.pause();
                                              await blue.characteristic
                                                  .setNotifyValue(false);
                                              //await blue.cancelNotify();
                                              //await streamSubscription.cancel();

                                              /* sensorData = await blue
                                                  .sensorStream
                                                  .toList(); */
                                            }
                                        }
                                        //recording ? swatch.start() : swatch.pause();
                                        submittable = true;
                                      },
                                    ),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: 10,
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
                                    }),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                ),
                                RaisedButton(
                                  child: Text('Submit'),
                                  onPressed: () => _submit(swatch, sensorData),
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
