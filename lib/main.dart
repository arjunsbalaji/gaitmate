import 'package:flutter/material.dart';
import 'package:gaitmate/models/collection_model.dart';
import 'package:gaitmate/screens/dashboard_screen.dart';
import 'screens/tabs_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Collection _collection = collections[0];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gait Mate',
      theme: ThemeData(
        primaryColor: Color(0xFF3EBACE),
        accentColor: Color(0xFFD8ECF1),
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TabScreen(),
      routes: {
        DashboardScreen.routeName: (ctx) => DashboardScreen(),
      },
    );
  }
}
