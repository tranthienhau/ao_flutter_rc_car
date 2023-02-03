import 'dart:developer';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ConnectionController {
  List<BluetoothDiscoveryResult> _results = [];
  BluetoothConnection? connection;
  final FlutterBluetoothSerial bl = FlutterBluetoothSerial.instance;

  Future startDiscover(Function(BluetoothDiscoveryResult)? onDiscover) async {
    bl.startDiscovery().listen((result) {
      final duplicate = _results.indexWhere(
          (element) => element.device.address == result.device.address);
      if (duplicate >= 0) {
        _results[duplicate] = result;
      } else if (result.device.name?.contains('JDY') == true) {
        _results = [..._results, result];
        onDiscover?.call(result);
      }
    });
  }

  Future<bool?> connectDevice(String address, {Function()? onComplete}) async {
    await BluetoothConnection.toAddress(address).then((mConnection) {
      connection = mConnection;
      onComplete?.call();
      getDeviceStatus();
    });

    return true;
  }

  Future getDeviceStatus() async {
    bl.onStateChanged().listen((state) {
      log("${state.isEnabled}");
    });
  }
}
