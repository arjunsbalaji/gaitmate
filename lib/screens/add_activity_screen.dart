import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/add_activity_form.dart';
import 'package:gaitmate/providers/stopwatch.dart';

class AddActivityScreen extends StatefulWidget {
  final User user;
  AddActivityScreen(this.user);

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MyStopwatch(),
        )
      ],
      child: Scaffold(body: AddActivityForm(widget.user))
      );
  }
}
