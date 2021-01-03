import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import '../widgets/add_activity_form.dart';
import 'package:gaitmate/providers/stopwatch.dart';
import '../Services/blue.dart';

class AddActivityScreen extends StatefulWidget {
  final User user;
  AddActivityScreen(this.user);

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  Blue fBlue = Blue();

  @override
  void didChangeDependencies() async {
    try {
      fBlue.checkBluetoothStatus();
    } on Exception catch (e) {
      print(e);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    fBlue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyStopwatch(),
          )
        ],
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  fBlue.connectDevice();
                  fBlue.getCharacteristic();
                  fBlue.listenCharacteristic();
                },
              ),
            ],
          ),
          body: AddActivityForm(widget.user),
        ));
  }
}
