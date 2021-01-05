import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';

enum BTStatus { unavailable, off, scanning, connected, disconnected }

class BlueProvider with ChangeNotifier {
  FlutterBlue fBlue = FlutterBlue.instance;
  BluetoothDevice device;
  BluetoothCharacteristic characteristic;

  bool connected = false;
  bool isOn = false;
  bool isAvailable = false;
  bool scanning = false;

  BTStatus _status = BTStatus.unavailable;

  BTStatus get status {
    return _status;
  }

  Stream<BluetoothDeviceState> get deviceState {
    if (device != null) {
      return device.state;
    } else {
      throw Exception('no device');
    }
  }

  BlueProvider();

  List<List<int>> sensorData = [];

  static const String _serviceUUID = '6e400001-b5a3-f393-e0a9-e50e24dcca9e';
  static const DeviceIdentifier deviceIdentifier =
      DeviceIdentifier('AC:67:B2:46:81:72');

  Future<void> updateBluetoothStatus() async {
    try {
      device = null;
      isOn = await fBlue.isOn;
      isAvailable = await fBlue.isAvailable;
      bool connected =
          await fBlue.connectedDevices.then((value) => value.length == 1);
      //bool connected = (device != null) ? true : false;
      //can write a little check func here that tests getting listen
      if (connected) {
        fBlue.connectedDevices.then(
          (value) {
            device = value[0];
            _status = BTStatus.connected;
            notifyListeners();
          },
        );
      } else {
        print('Device not already connected, trying to connect now!');
        connectDevice();
      }
      //int status = [isAvailable, isOn, connected]
      //    .lastIndexWhere((element) => element == true);
      //_status = BTStatus.values[status];
      //notifyListeners();
      //print(connected.toString());
      print('INSIDE UPDATE BT ' + device.toString());
    } catch (e) {
      print(e);
    }
  }

  void connectDevice() {
    _status = BTStatus.scanning;
    notifyListeners();
    try {
      fBlue.startScan(timeout: Duration(seconds: 2));

      //add if already connected then just pass done change state to scanning

      fBlue.scanResults.listen(
        (results) {
          print(results.toString());
          ScanResult correctResult = results
              .where((element) => element.device.id == deviceIdentifier)
              .toList()[0];
          device = correctResult.device;
          if (device == null) {
            _status = BTStatus.off;
            throw Exception(
                'Device not found, make sure to turn on BT and the device.');
          } else {
            device.connect();
            _status = BTStatus.connected;
            notifyListeners();
          }
        },
      );
    } catch (e) {
      print(e);
    } finally {
      fBlue.stopScan();
    }
    print('INSIDE CONNECT DEVICE ${(device != null)}');
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

/*   Future<StreamSubscription> listenSensorData() async {
    await characteristic.setNotifyValue(true);
    streamSubscription =
        characteristic.value.map((event) => utf8.decode(event)).listen((event) {
      List<int> cleaned_event = event
          .substring(0, event.length - 1)
          .split(',')
          .map((e) => int.parse(e))
          .toList();
      return streamSubscription;
      //sensorData.add(cleaned_event);
      //print(cleaned_event.toString());
    });
  }
 */
  void empty() {
    if (device != null) {
      device.disconnect();
      device = null;
    }
    sensorData = [];
    _status = BTStatus.off;

    notifyListeners();
  }
}
