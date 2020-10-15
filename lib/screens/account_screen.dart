import 'package:flutter/material.dart';
import 'package:gaitmate/providers/details.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/details_screen.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*   Map<String, Object> userProperties =
        Provider.of<Details>(context, listen: true).userProperties; */
    return FutureBuilder(
      future: Provider.of<Details>(
        context,
        listen: false,
      ).fetchAndSetDetails(),
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<Details>(
              builder: (ctx, details, ch) => Center(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(height: 300),
                      Text('ACCOUNT SCREEN'),
                      Text('${details.userProperties['weight']}'),
                      RaisedButton(
                        child: Text('Details'),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(DetailsScreen.routeName);
                        },
                      ),
                      FlatButton(
                        child: Text('LOGOUT'),
                        onPressed: () {
                          print(
                              Provider.of<Auth>(context, listen: false).token);
                          Provider.of<Auth>(context, listen: false).logout();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
