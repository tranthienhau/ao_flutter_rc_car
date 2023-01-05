import 'dart:async';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:hc05/controller/monitor_controller.dart';
import 'package:hc05/controller/moving_controller.dart';

import 'connection_controller.dart';

abstract class CarService {
  connectDevice(String address);
  disconnectDevice();
  startDiscover(Function(BluetoothDiscoveryResult result)? onDiscover);
  go(Direction direction);
  stop(Direction direction);
  horn(bool onPressed);
  frontLight(bool onPressed);
  backLight(bool onPressed);
  setSpeed(Speed speed);
}

class CarServiceImpl extends CarService {
  final StreamController<Map<String, bool>> _movingStream = StreamController();
  final StreamController<MonitorAction> _monitorStream = StreamController();

  late final MovingController _movingController;
  late final MonitorController _monitorController;
  late final ConnectionController _connectController = ConnectionController();
  @override
  connectDevice(String address) {
    _connectController.connectDevice(address, onComplete: () {
      _movingController =
          MovingController(_movingStream, _connectController.connection)
            ..getController();
      _monitorController =
          MonitorController(_monitorStream, _connectController.connection)
            ..getController();
    });
  }

  @override
  disconnectDevice() {
    // _connectController.
  }

  @override
  go(Direction direction) {
    _movingStream.add({direction.name: true});
  }

  @override
  stop(Direction direction) {
    _movingStream.add({direction.name: false});
  }

  @override
  startDiscover(Function(BluetoothDiscoveryResult result)? onDiscover) {
    _connectController.startDiscover((result) => onDiscover?.call(result));
  }

  @override
  backLight(bool onPressed) {
    onPressed
        ? _monitorStream.add(MonitorAction.backLightsOn)
        : _monitorStream.add(MonitorAction.backLightsOff);
  }

  @override
  frontLight(bool onPressed) {
    onPressed
        ? _monitorStream.add(MonitorAction.frontLightsOn)
        : _monitorStream.add(MonitorAction.frontLightsOff);
  }

  @override
  horn(bool onPressed) {
    onPressed
        ? _monitorStream.add(MonitorAction.hornOn)
        : _monitorStream.add(MonitorAction.hornOff);
  }

  @override
  setSpeed(Speed speed) {
    _monitorController.setSpeed(speed);
  }
}
