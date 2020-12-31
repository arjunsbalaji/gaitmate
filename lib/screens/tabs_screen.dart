import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaitmate/screens/newdetailsScreen.dart';
import './account_screen.dart';
import './dashboard_screen.dart';
import 'package:gaitmate/helpers/size_config.dart';
import 'package:gaitmate/providers/userDetails.dart';

class TabScreen extends StatefulWidget {

  final User user;
  final Duration needDetails;

  TabScreen(this.user, this.needDetails);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPage = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': DashboardScreen(widget.user),
        'title': 'Dashboard',
      },
      {
        'page': AccountScreen(widget.user),
        'title': 'Accounts',
      }
    ];

    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      //print(index);
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return widget.needDetails < Duration(seconds:10)
    ? NewDetailsScreen(widget.user, new UserDetails())
    : Scaffold(
      body: SafeArea(
        child: _pages[_selectedPage]['page'],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 36.0,
        currentIndex: _selectedPage,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).accentColor,
        selectedFontSize: 0,
        onTap: _selectPage,
        items: [
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.dashboard,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: CircleAvatar(
              radius: 15.0,
            ),
          ),
        ],
      ),
    );
  }
}
