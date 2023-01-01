import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:hc05/car_controller.dart';

class BluetoothViewmodel extends ChangeNotifier {
  BluetoothViewmodel();
  List<BluetoothDiscoveryResult> results = [];
  final StreamController<Map<String, bool>> _directions = StreamController();
  late final CarController _controller = CarControllerImpl(_directions);

  go(Direction direction) {
    _directions.add({direction.name: true});
  }

  stop(Direction direction) {
    _directions.add({direction.name: false});
  }

  connectDevice(String address) {
    _controller.connectDevice(address);
  }

  startDiscover() {
    _controller.startDiscover((result) {
      results = [...results, result];
      notifyListeners();
    });
  }
}
