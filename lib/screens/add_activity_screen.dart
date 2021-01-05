import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:gaitmate/providers/blue_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/add_activity_form.dart';
import 'package:gaitmate/providers/stopwatch.dart';
//import '../Services/blue.dart';

class AddActivityScreen extends StatefulWidget {
  final User user;
  AddActivityScreen(this.user);

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  //Blue fBlue = Blue();

  @override
  void didChangeDependencies() async {
    try {
      //fBlue.checkBluetoothStatus();
    } on Exception catch (e) {
      print(e);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //fBlue.dispose();
    super.dispose();
  }

  Future<void> _showBTStatusAlertDialog(BTStatus status) async {
    //bool status = await fBlue.checkBluetoothStatus();
    return status == BTStatus.off || status == BTStatus.unavailable
        ? null
        : showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Bluetooth Status'),
                content: Text(
                    'Bluetooth is not available. Try turning on Bluetooth and the device.'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'))
                ],
              );
            },
          );
  }

  Widget showBTStatusButton(BTStatus status) {
    List<Color> colors = [
      Colors.black26,
      Colors.grey,
      Colors.amber,
      Colors.green,
      Colors.red
    ];
    List<String> msgs = [
      'unavailable',
      'off',
      'scanning',
      'connected',
      'disconnected'
    ];

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), side: BorderSide.none),
      color: colors[status.index],
      onPressed: () {},
      icon: Icon(Icons.bluetooth),
      label: Text(msgs[status.index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    //bool status = true;
    //_showBTStatusAlertDialog();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MyStopwatch(),
        ),
        ChangeNotifierProvider(
          create: (context) => BlueProvider(),
        ),
      ],
      builder: (context, child) {
        return Scaffold(
          body: AddActivityForm(widget.user),
        );
      },
    );
  }
}
