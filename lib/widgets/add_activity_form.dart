import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaitmate/providers/collection.dart';
import 'package:gaitmate/providers/stopwatch.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math';
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
  );

  bool recording = false;
  bool submittable = false;
  bool isLoading = false;

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
      //String id = DateTime.now().millisecondsSinceEpoch.toString();
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
    //
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                        );
                      },
                    ),
                  ),
                  Container(
                    //color: Colors.purple,
                    alignment: Alignment.center,
                    child: DropdownButton<String>(
                      value: dropType,
                      icon: Icon(Icons.arrow_drop_down),
                      elevation: 16,
                      style: TextStyle(color: Theme.of(context).primaryColor),
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
                          );
                          print(dropType);
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
                  Container(
                    child: Text(
                      swatch.totalDuration,
                      style: TextStyle(
                        fontSize: 90.0,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 80,
                    width: 80,
                    child: RaisedButton(
                      color: recording
                          ? Colors.redAccent
                          : Theme.of(context).primaryColor,
                      elevation: 10.0,
                      child: Container(
                        //color: Colors.blue,
                        width: 40,
                        height: 40,
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
                        print(recording);
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
                              width: 20,
                              height: 100,
                            ),
                            RaisedButton(
                              child: Text('Submit'),
                              onPressed: () => _submit(swatch),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 100,
                          width: 10,
                        ),
                ],
              ),
      ),
    );
  }
}
