import 'package:flutter/material.dart';
import 'package:gaitmate/providers/collection.dart';
import 'package:gaitmate/providers/stopwatch.dart';
import 'package:gaitmate/screens/auth_screen.dart';
import 'package:gaitmate/screens/dashboard_screen.dart';
import 'package:gaitmate/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import './screens/tabs_screen.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //Collection _collection = collections[0];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Collection>(
          //create: (_) => null,
          update: (ctx, auth, prevCollection) => Collection(
            'Name',
            'Bio',
            auth.token,
            auth.userId,
            prevCollection == null ? [] : prevCollection.activities,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => MyStopwatch(),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Gait Mate',
          theme: ThemeData(
            primaryColor: Color(0xFF3EBACE),
            accentColor: Color(0xFFD8ECF1),
            scaffoldBackgroundColor: Color(0xFFF3F5F7),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth
              ? TabScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            TabScreen.routeName: (ctx) => TabScreen(),
            DashboardScreen.routeName: (ctx) => DashboardScreen(),
          },
        ),
      ),
    );
  }
}
