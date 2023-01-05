import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ConnectionController {
  List<BluetoothDiscoveryResult> _results = [];
  BluetoothConnection? connection;

  Future startDiscover(Function(BluetoothDiscoveryResult)? onDiscover) async {
    FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
      final duplicate = _results.indexWhere(
          (element) => element.device.address == result.device.address);
      if (duplicate >= 0) {
        _results[duplicate] = result;
      } else {
        if (result.device.name?.contains('JDY') == true) {
          _results = [..._results, result];
          onDiscover?.call(result);
        }
      }
    });
  }

  Future<bool?> connectDevice(String address, {Function()? onComplete}) async {
    BluetoothConnection.toAddress(address).then((mConnection) {
      connection = mConnection;
    }).whenComplete(() {
      onComplete?.call();
    });

    return true;
  }
}
