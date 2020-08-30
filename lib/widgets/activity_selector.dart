import 'package:flutter/material.dart';

class ActivitySelector extends StatefulWidget {
  @override
  _ActivitySelectorState createState() => _ActivitySelectorState();
}

class _ActivitySelectorState extends State<ActivitySelector> {
  Map<String, Object> _selections;

  @override
  void initState() {
    Map<String, Object> _selections = {
      'runs': 0,
      'walks': 0,
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_selections);
    return Container();
  }
}
