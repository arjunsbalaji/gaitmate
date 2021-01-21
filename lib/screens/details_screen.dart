import 'package:flutter/material.dart';
import 'package:gaitmate/providers/details.dart';
import 'package:provider/provider.dart';
import '../helpers/db_helper.dart';

class DetailsScreen extends StatefulWidget {
  static const routeName = '/details';
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _formkey = GlobalKey<FormState>();

  final weightController = TextEditingController();

  //currently implemetned stock may clean this up with a class later
  //String weight;
  Map<String, Object> newUserProperties = {
    'id': 'hello',
    'weight': '0',
  };

  void _saveDetails() {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      Provider.of<Details>(context, listen: false)
          .updateUserProperties(newUserProperties);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Object> userProperties =
        Provider.of<Details>(context, listen: false).userProperties;

    return Scaffold(
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 80),
              child: TextFormField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'current weight =  ${userProperties['weight']} kg',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Invalid Weight';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  newUserProperties['weight'] = newValue.toString();
                },
              ),
            ),
            IconButton(icon: Icon(Icons.save), onPressed: () => _saveDetails())
          ],
        ),
      ),
    );
  }
}
