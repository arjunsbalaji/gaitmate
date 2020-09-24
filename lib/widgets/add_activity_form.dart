import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaitmate/providers/collection.dart';
import 'package:gaitmate/providers/stopwatch.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../providers/stopwatch.dart';

class AddActvityForm extends StatefulWidget {
  @override
  _AddActvityFormState createState() => _AddActvityFormState();
}

class _AddActvityFormState extends State<AddActvityForm> {
  final _formKey = GlobalKey<FormState>();
  String dropType = 'run';
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final notesController = TextEditingController();
  Random random = new Random(); //this is just here for now
  //Stopwatch stopwatch = new Stopwatch();
  bool recording = false;
  bool submittable = false;

  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';

  bool isLoading = false;

  void _recordChange() {
    setState(() {
      recording = !recording;
    });
  }

  void _submit(MyStopwatch swatch, Collection collection) {
    if (_formKey.currentState.validate()) {
      //IF I AM
      //RECORDING AND GO OFF THE PAGE TIMER ISNT CANCELLED
      //SO NEED TO PUT THAT IN
      //String id = DateTime.now().millisecondsSinceEpoch.toString();
      setState(() {
        isLoading = true;
      });
      String notes = notesController.text;
      Duration elapsedTime = Duration(seconds: swatch.counter);
      DateTime startTime = DateTime.now();
      collection
          .addActivity(
        notes,
        dropType,
        {
          'gyro': 10,
          'accel': [1, 2, 3],
        },
        startTime,
        elapsedTime,
        startTime.add(elapsedTime),
      )
          .then(
        (_) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(dropType + ' Added!'),
              content: Text('Success!'),
              //can put actions here
            ),
          );
        },
      );
      swatch.reset();
      setState(
        () {
          isLoading = false;
        },
      );
      print(hoursStr + minutesStr + secondsStr);
    }
  }

  @override
  Widget build(BuildContext context) {
    Collection collection = Provider.of<Collection>(context);
    MyStopwatch swatch = Provider.of<MyStopwatch>(context);
    return Form(
      key: _formKey,
      child: Container(
        //color: Colors.yellow,
        padding: EdgeInsets.all(10),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
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
                        }),
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
                          dropType = newValue;
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
                      ? RaisedButton(
                          child: Text('Submit'),
                          onPressed: () => _submit(swatch, collection),
                        )
                      : SizedBox(
                          height: 10,
                          width: 10,
                        ),
                ],
              ),
      ),
    );
  }
}
