import 'package:flutter/material.dart';
import 'package:gaitmate/providers/collection.dart';
import 'package:intl/intl.dart';

class AddActvityForm extends StatefulWidget {
  @override
  _AddActvityFormState createState() => _AddActvityFormState();
}

class _AddActvityFormState extends State<AddActvityForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.lime,
            child: TextFormField(
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
          RaisedButton(
              child: Text('Submit'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  print('submit');
                }
              }),
        ],
      ),
    );
  }
}
