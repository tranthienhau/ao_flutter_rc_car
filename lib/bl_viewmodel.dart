import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:hc05/controller/car_service.dart';

import 'controller/monitor_controller.dart';
import 'controller/moving_controller.dart';

class BluetoothViewmodel extends ChangeNotifier {
  BluetoothViewmodel(this.service);
  List<BluetoothDiscoveryResult> results = [];
  final CarService service;
  go(Direction direction) {
    service.go(direction);
  }

  stop(Direction direction) {
    service.stop(direction);
  }

  connectDevice(String address) {
    service.connectDevice(address);
  }

  setSpeed(Speed speed) {
    service.setSpeed(speed);
  }

  frontLight(bool onPress) {
    service.frontLight(onPress);
  }

  horn(bool onPress) {
    service.horn(onPress);
  }

  backLight(bool onPress) {
    service.backLight(onPress);
  }

  startDiscover() {
    service.startDiscover((result) {
      results = [...results, result];
      notifyListeners();
    });
  }
}
