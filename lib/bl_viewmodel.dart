import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:hc05/car_controller.dart';

class BluetoothViewmodel extends ChangeNotifier {
  List<BluetoothDiscoveryResult> results = [];
  StreamController<Map<String, bool>> directions = StreamController();
  BluetoothViewmodel();
  late CarController controller = CarControllerImpl(directions);

  go(Direction direction) {
    directions.add({direction.name: true});
  }

  stop(Direction direction) {
    directions.add({direction.name: false});
  }

  connectDevice(String address) {
    controller.connectDevice(address);
  }

  startDiscover() {
    controller.startDiscover((result) {
      results = [...results, result];
      notifyListeners();
    });
  }
}
