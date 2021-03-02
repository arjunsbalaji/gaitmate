import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaitmate/providers/auth.dart';
import 'package:gaitmate/screens/avatar.dart';
import 'package:gaitmate/providers/userDetails.dart';
import 'package:gaitmate/Services/database.dart';
import 'package:provider/provider.dart';
import 'package:gaitmate/screens/detailsScreen.dart';
import 'package:gaitmate/helpers/size_config.dart';

class AccountScreen extends StatefulWidget {
  final User user;
  AccountScreen(this.user);
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  
  UserDetails userDetails;

  Future<void> asyncFindUserDetails () async {
    await findUserDetails(widget.user).then((userDetails) => {
      this.setState(() {
        this.userDetails = userDetails;
      })
    });
  }
  void initState () {
    super.initState();
    asyncFindUserDetails();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Theme.of(context).primaryColor, Theme.of(context).accentColor,]
                ),
              ),
              child: userDetails == null
              ? Center(child:CircularProgressIndicator())
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Avatar(
                    avatarUrl: userDetails?.avatarUrl,
                    onTap: (){},
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal*5),
                  Text(
                    "Hello, ${userDetails?.displayName ?? 'nice to see you'}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal*5),
                  Text('Weight: ${userDetails.weight} kg'),
                  SizedBox(height: SizeConfig.blockSizeHorizontal*5),
                  Text('Height: ${userDetails.height} cm'),
                  SizedBox(height: SizeConfig.blockSizeHorizontal*5),
                  RaisedButton(
                    child: Text('Details'),
                    onPressed: () {
                      _navigatorAndReload(context);
                    },
                  ),
                  FlatButton(
                    child: Text('LOGOUT'),
                    onPressed: () {
                      context.read<AuthenticationService>().signOut();
                    },
                    )
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
  _navigatorAndReload(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          widget.user,
          userDetails,
        ),
      ),
    );
    setState(() {
      asyncFindUserDetails();
    });
  }
}