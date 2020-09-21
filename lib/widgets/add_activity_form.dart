import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaitmate/providers/collection.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../streams/stopwatch.dart';

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
  Stopwatch stopwatch = new Stopwatch();
  bool recording = false;

  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';

  void _recordChange() {
    setState(() {
      recording = !recording;
    });
  }

  @override
  Widget build(BuildContext context) {
    Collection collection = Provider.of<Collection>(context);
    return Form(
      key: _formKey,
      child: Container(
        //color: Colors.yellow,
        padding: EdgeInsets.all(10),
        child: Column(
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
                "$hoursStr:$minutesStr:$secondsStr",
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
                        recording ? Icon(Icons.stop) : Icon(Icons.play_arrow),
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
                    if (_formKey.currentState.validate()) {
                      _recordChange();
                      var timerStream = stopWatchStream();
                      var timerSubscription = timerStream.listen((int newTick) {
                        setState(() {
                          hoursStr = ((newTick / (60 * 60)) % 60)
                              .floor()
                              .toString()
                              .padLeft(2, '0');
                          minutesStr = ((newTick / 60) % 60)
                              .floor()
                              .toString()
                              .padLeft(2, '0');
                          secondsStr =
                              (newTick % 60).floor().toString().padLeft(2, '0');
                        });
                      });
                      print(recording.toString());
                      String id =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      DateTime startTime = DateTime.now();
                      Duration duration = stopwatch.elapsed;
                      DateTime endTime = DateTime.now().add(
                        new Duration(seconds: 30),
                      );
/*                       collection.addActivity(
                          id,
                          notesController.text,
                          dropType,
                          {
                            'gyro': random.nextInt(10),
                            'lin': random.nextInt(10),
                            'value': random.nextInt(10)
                          },
                          startTime,
                          duration,
                          endTime); */
                      //print('submit');
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
