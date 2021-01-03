import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
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

  //TEMPBLUETOOTH UUID

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

/*   @override
  void didChangeDependencies() async {
    try {
      bool available = await flutterBlue.isAvailable;
      bool isOn = await flutterBlue.isOn;
      isOn && available ? print('On and Available') : print('Not On');
    } on Exception catch (e) {
      print(e);
    }
    super.didChangeDependencies();
  } */

  void _selectPage(int index) {
    setState(() {
      //print(index);
      _selectedPage = index;
    });
  }

/*   Future<void> getServices(device) async {
    List<BluetoothService> services = await device.discoverServices();
    print('SERVICES LENGTH ${services.length}');
    BluetoothService service = services
        .firstWhere((service) => service.uuid.toString() == _service_UUID);
    print('SERVICE ${service.uuid.toString()}');
    BluetoothCharacteristic char =
        service.characteristics.firstWhere((c) => c.properties.notify == true);
    print(char.properties.toString());
    printChar(char);
  }

  Future<void> printChar(BluetoothCharacteristic characteristic) async {
    await characteristic.setNotifyValue(true);
    StreamSubscription charStream = characteristic.value.listen(
      (value) {
        print(value.toString());
      },
    );
    charStream.onError((e) => print(e));
  }

  FlutterBlue flutterBlue = FlutterBlue.instance; */

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return widget.needDetails < Duration(seconds: 10)
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
