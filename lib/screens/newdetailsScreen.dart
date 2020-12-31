import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaitmate/providers/userDetails.dart';
import 'package:gaitmate/Services/database.dart';
import 'package:gaitmate/helpers/size_config.dart';
import 'package:gaitmate/screens/tabs_screen.dart';

class NewDetailsScreen extends StatefulWidget {
  User user;
  UserDetails userDetails;

  NewDetailsScreen(this.user, this.userDetails);

  @override
  _NewDetailsScreenState createState() => _NewDetailsScreenState();

}

class _NewDetailsScreenState extends State<NewDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _pmhxController = TextEditingController();
  final TextEditingController _alcoholController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nsmokeController = TextEditingController();

  @override
  Widget build(BuildContext context){
    _weightController.text = widget.userDetails.weight;
    _heightController.text = widget.userDetails.height;
    _pmhxController.text = widget.userDetails.pastMedhx;
    _alcoholController.text = widget.userDetails.alcohol;
    _firstNameController.text = widget.userDetails.firstName;
    _lastNameController.text = widget.userDetails.lastName;
    _lastNameController.text = widget.userDetails.lastName;
    _nsmokeController.text = widget.userDetails.nsmoke;

    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        leading: widget.userDetails.weight == null ? Icon(Icons.person) : BackButton(),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                  //initialValue: widget.userDetails.firstName,
                  validator: (value) {
                    if (value.isEmpty) {
                      return ('Please enter your first name');
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                  //initialValue: widget.userDetails.lastName,
                  validator: (value) {
                    if (value.isEmpty) {
                      return ('Please enter your first name');
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _weightController,
                  decoration: InputDecoration(labelText: 'Enter weight (kg)'),
                  //initialValue: widget.userDetails.weight == null ? null : widget.userDetails.weight + ' kg',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final isDigitsOnly = int.tryParse(value);
                    if (value.isEmpty || isDigitsOnly==null) {
                      return ('Please enter a number');
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _heightController,
                  decoration: InputDecoration(labelText: 'Enter height (cm)'),
                  //initialValue: widget.userDetails.height == null ? null: widget.userDetails.height + ' cm',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final isDigitsOnly = int.tryParse(value);
                    if (value.isEmpty || isDigitsOnly==null) {
                      return ('Please enter a number');
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _pmhxController,
                  decoration: InputDecoration(labelText: 'Relevant past medical history'),
                  //initialValue: widget.userDetails.pastMedhx,
                ),
                TextFormField(
                  controller: _alcoholController,
                  decoration: InputDecoration(labelText: 'Describe your alcohol use'),
                  //initialValue: widget.userDetails.alcohol,
                ),
                TextFormField(
                  controller: _nsmokeController,
                  decoration: InputDecoration(labelText: 'Number of cigarettes per day'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return ('Please enter a number');
                    }
                    return null;
                  },
                ),
                SizedBox(height: SizeConfig.blockSizeHorizontal*5),
                RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      updateDetails(widget.user, new UserDetails(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        weight: _weightController.text,
                        height: _heightController.text,
                        pastMedhx: _pmhxController.text,
                        alcohol: _alcoholController.text,
                        nsmoke: _nsmokeController.text,

                      ));
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => TabScreen(widget.user, Duration(seconds: 20))));
                    }},
                  child:Text('Update details'),
                )
              ],
            ),
          ),
        )
      )
    );
  }
}