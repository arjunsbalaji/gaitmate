import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';
import '../Services/blue.dart';

class BlueProvider with ChangeNotifier {
  FlutterBlue fBlue = FlutterBlue.instance;
  BluetoothDevice device;
  BluetoothCharacteristic characteristic;

  bool connected = false;
  bool isOn = false;
  bool isAvailable = false;

  BlueProvider();

  List<List<int>> sensorData = [];

  static const String _serviceUUID = '6e400001-b5a3-f393-e0a9-e50e24dcca9e';
  static const DeviceIdentifier deviceIdentifier =
      DeviceIdentifier('AC:67:B2:46:81:72');

  Future<bool> checkBluetoothStatus() async {
    isOn = await fBlue.isOn;
    isAvailable = await fBlue.isAvailable;
    notifyListeners();
    isOn ? print('On') : print('Not On');
    isAvailable ? print('Available') : print('Not available');
    return (isOn && isAvailable) ? true : false;
  }

  void connectDevice() async {
    fBlue.startScan(timeout: Duration(seconds: 2));

    var subscription = fBlue.scanResults.listen(
      (results) {
        for (ScanResult r in results) {
          //print(r.device.id);
          if (r.device.id == deviceIdentifier) {
            device = r.device;
            device.connect();
            print(
                'INSIDE CONNECT DEVICE DEVICE ID IS: ${device.id.toString()}');
            connected = true;
            notifyListeners();
          }
        }
      },
    );
    if (connected != true) {
      print('BLUETOOTH GAITMATE DEVICE NOT CONECTED, TRY TURNING IT ON');
    }
    await fBlue.stopScan();

    //List<BluetoothDevice> cd = await fBlue.connectedDevices;
    //print('CONNECTED DEVICES LIST: ${cd.toString()}');
  }

  void getCharacteristic() async {
    List<BluetoothService> services = await device.discoverServices();
    //print('SERVICES LENGTH ${services.length}');
    //print(services[2].toString());
    BluetoothService service =
        services.firstWhere((s) => s.uuid.toString() == _serviceUUID);
    //print('SERVICE ${service.toString()}');
    //print(service.characteristics.toString());
    characteristic =
        service.characteristics.firstWhere((c) => c.properties.notify == true);
    //print(' CHAR PROPS ${characteristic.properties.toString()}');
  }

  void listenCharacteristic() async {
    await characteristic.setNotifyValue(true);
    characteristic.value.map((event) => utf8.decode(event)).listen((event) {
      List<int> cleaned_event = event
          .substring(0, event.length - 1)
          .split(',')
          .map((e) => int.parse(e))
          .toList();
      sensorData.add(cleaned_event);
      //print(cleaned_event.toString());
    });
  }

  void empty() {
    this.device.disconnect();
    sensorData = [];
    connected = false;
    notifyListeners();
  }
}
