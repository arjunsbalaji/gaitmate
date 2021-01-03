import 'dart:async';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Blue {
  FlutterBlue fBlue = FlutterBlue.instance;
  BluetoothDevice device;
  BluetoothCharacteristic characteristic;

  bool _connected = false;

  Blue();

  static const String _serviceUUID = '6e400001-b5a3-f393-e0a9-e50e24dcca9e';
  static const DeviceIdentifier deviceIdentifier =
      DeviceIdentifier('AC:67:B2:46:81:72');

  void checkBluetoothStatus() async {
    bool isOn = await fBlue.isOn;
    bool isAvailable = await fBlue.isAvailable;

    isOn ? print('On') : print('Not On');
    isAvailable ? print('Available') : print('Not available');
  }

  void connectDevice() async {
    fBlue.startScan(timeout: Duration(seconds: 4));

    var subscription = fBlue.scanResults.listen(
      (results) {
        for (ScanResult r in results) {
          //print(r.device.id);
          if (r.device.id == deviceIdentifier) {
            device = r.device;
            device.connect();
            print(
                'INSIDE CONNECT DEVICE DEVICE ID IS: ${device.id.toString()}');
            _connected = true;
          }
        }
      },
    );
    if (_connected != true) {
      print('BLUETOOTH GAITMATE DEVICE NOT CONECTED, TRY TURNING IT ON');
    }
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
    print(' CHAR PROPS ${characteristic.properties.toString()}');
  }

  void listenCharacteristic() async {
    await characteristic.setNotifyValue(true);
    characteristic.value.map((event) => utf8.decode(event)).listen((event) {
      List<String> cleaned_event =
          event.substring(0, event.length - 1).split(',');
      //print(cleaned_event.toString());
    });
  }

  void dispose() {
    this.device.disconnect();
    _connected = false;
  }
}
