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

  /* StreamController<List<int>> sensorStreamController =
      StreamController<List<int>>(); */
  Stream<List<int>> sensorStream;

  BTStatus _status = BTStatus.unavailable;

  BTStatus get status {
    return _status;
  }

  Stream<BluetoothDeviceState> get deviceState {
    if (device != null) {
      return device.state;
    } else {
      return Stream.periodic(Duration(seconds: 10), (_) {
        return BluetoothDeviceState.disconnected;
      });
    }
  }

  BlueProvider();

  List<List<int>> sensorData = [];

  static const String _serviceUUID = '6e400001-b5a3-f393-e0a9-e50e24dcca9e';
  static const DeviceIdentifier deviceIdentifier =
      DeviceIdentifier('AC:67:B2:46:81:72');

  Future<void> updateBluetoothStatus() async {
    try {
      //device = null;
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

  Future<void> connectDevice() async {
    /* _status = BTStatus.scanning;
    notifyListeners(); */
    bool connected =
        await fBlue.connectedDevices.then((value) => value.length == 1);
    //bool connected = (device != null) ? true : false;
    //can write a little check func here that tests getting listen
    if (connected) {
      fBlue.connectedDevices.then(
        (value) {
          print('connected is true looking in .connected devices');
          device = value[0];
          //_status = BTStatus.connected;
          //notifyListeners();
        },
      );
    } else {
      try {
        print('doing scan no conn device.');
        await fBlue.startScan(timeout: Duration(seconds: 5));

        //add if already connected then just pass done change state to scanning

        fBlue.scanResults.listen(
          (results) async {
            print(results.toString());
            ScanResult correctResult = results
                .where((element) => element.device.id == deviceIdentifier)
                .toList()[0];
            device = correctResult.device;
            print('std connect');
            if (device == null) {
              print('preexcept');
              //_status = BTStatus.off;
              throw Exception(
                  'Device not found, make sure to turn on BT and the device.');
            } else {
              await device.connect();
              print('else');
              //_status = BTStatus.connected;
              //notifyListeners();
            }
          },
        );
      } catch (e) {
        print(e);
      } finally {
        fBlue.stopScan();
        print('1INSIDE CONNECT DEVICE ${(device != null)}');
      }
    }
    print('2INSIDE CONNECT DEVICE ${(device == null)}');
  }

  Future<void> getCharacteristic() async {
    List<BluetoothService> services = await device.discoverServices();
    //print('SERVICES LENGTH ${services.length}');
    //print(services[2].toString());
    BluetoothService service =
        services.firstWhere((s) => s.uuid.toString() == _serviceUUID);
    //print('SERVICE ${service.toString()}');
    //print(service.characteristics.toString());m
    characteristic =
        service.characteristics.firstWhere((c) => c.properties.notify == true);
    //print(' CHAR PROPS ${characteristic.properties.toString()}');
    await characteristic.setNotifyValue(true);
    sensorStream = characteristic.value
        .map((event) => utf8.decode(event))
        .map((event) => event
            .substring(0, event.length - 1)
            .split(',')
            .map((e) => int.parse(e))
            .toList())
        .asBroadcastStream();
  }

  void getSensorDataStream() async {
    //await characteristic.setNotifyValue(true);
    sensorStream = characteristic.value.map((event) => utf8.decode(event)).map(
        (event) => event
            .substring(0, event.length - 1)
            .split(',')
            .map((e) => int.parse(e))
            .toList());
    /* .listen((event) {
      List<int> cleaned_event = event
          .substring(0, event.length - 1)
          .split(',')
          .map((e) => int.parse(e))
          .toList();  */
    //sensorData.add(cleaned_event);
    //print(cleaned_event.toString());
  }
/* 
  Stream<List<int>> sensorDataStream() {
    Stream<List<int>> getStream() {
      return this.characteristic.value.map((event) => utf8.decode(event)).map(
          (event) => event
              .substring(0, event.length - 1)
              .split(',')
              .map((e) => int.parse(e))
              .toList());
      /* .listen((event) {
        /* List<int> cleaned_event = event.substring(0, event.length - 1)
          .split(',')
          .map((e) => int.parse(e))
          .toList();  */
        return event;
      }); */
    }

    controller = StreamController<List<int>>(
      onListen: getStream,
      onResume: getStream,
    );

    return controller.stream;
  } */

  Future<void> cancelNotify() async {
    await characteristic.setNotifyValue(false);
  }

  /*  Future<Stream<List<int>>> getSensorDataStream() async {
    await characteristic.setNotifyValue(true);
    return characteristic.value.map((event) => utf8.decode(event)).map(
        (event) => event
            .substring(0, event.length - 1)
            .split(',')
            .map((e) => int.parse(e))
            .toList());
    /*    .listen((event) {
      List<int> cleaned_event = event
          .substring(0, event.length - 1)
          .split(',')
          .map((e) => int.parse(e))
          .toList(); */
    //sensorData.add(cleaned_event);
    //print(cleaned_event.toString());
  } */

}
