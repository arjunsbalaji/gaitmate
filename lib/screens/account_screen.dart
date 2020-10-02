import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(children: [
          SizedBox(height: 300),
          Text('ACCOUNT SCREEN'),
          FlatButton(
            child: Text('LOGOUT'),
            onPressed: () {
              print(Provider.of<Auth>(context, listen: false).token);
              Provider.of<Auth>(context, listen: false).logout();
            },
          )
        ]),
      ),
    );
  }
}
