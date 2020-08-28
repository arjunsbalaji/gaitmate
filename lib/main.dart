import 'package:flutter/material.dart';
import './activity_screen.dart';
import './tabs_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
        ActivityScreen.routeName: (ctx) => ActivityScreen(),
      },
    );
  }
}
