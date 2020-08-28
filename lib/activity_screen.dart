import 'package:flutter/material.dart';
import './nav_bar.dart';

class ActivityScreen extends StatelessWidget {
  static const routeName = '/activity';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6.0,
                  offset: Offset(
                    0.0,
                    2.0,
                  ))
            ]),
        padding: EdgeInsets.all(15.0),
        child: Text('hello'),
      ),
    );
  }
}
