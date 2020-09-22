import 'package:flutter/material.dart';
import 'package:gaitmate/providers/collection.dart';
import 'package:gaitmate/providers/stopwatch.dart';
import 'package:gaitmate/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'screens/tabs_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //Collection _collection = collections[0];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Collection('DEMO TITLE (USER)', 'DEMO DESCRIPTION'),
        ),
        ChangeNotifierProvider(
          create: (_) => MyStopwatch(),
        )
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
