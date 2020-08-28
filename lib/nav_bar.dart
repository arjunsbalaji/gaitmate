import 'package:flutter/material.dart';
import 'package:gaitmate/activity_screen.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.search),
            color: Theme.of(context).primaryColor,
            iconSize: 44.0,
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          IconButton(
            icon: Icon(Icons.dashboard),
            color: Theme.of(context).primaryColor,
            iconSize: 44.0,
            onPressed: () {
              Navigator.pushReplacementNamed(context, ActivityScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
