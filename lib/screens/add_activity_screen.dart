import 'package:flutter/material.dart';
import '../widgets/add_activity_form.dart';

class AddActivityScreen extends StatefulWidget {
  static const routeName = '/add_activity_screen';
  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AddActvityForm(),
    );
  }
}
