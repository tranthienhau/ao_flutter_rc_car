import 'dart:async';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hc05/controller/monitor_controller.dart';
import 'package:hc05/controller/moving_controller.dart';
import 'package:rxdart/rxdart.dart';

import '../controller/connection_controller.dart';
import '../controller/gps_controller.dart';
import '../util/enum.dart';

abstract class CarService {
  Stream<LatLng> get coordinateData;
  Stream<Action> get carDirectionStream;
  Stream<bool> get deviceConnected;
  Future<void> connectDevice(String address);
  disconnectDevice();
  startDiscover(Function(BluetoothDiscoveryResult result)? onDiscover);
  go(Direction direction);
  stop(Direction direction);
  horn(bool onPressed);
  alert(bool onPressed);
  frontLight(bool onPressed);
  backLight(bool onPressed);
  setSpeed(Speed speed);
}

class CarServiceImpl extends CarService {
  final StreamController<Map<String, bool>> _movingStream = StreamController();
  final StreamController<MonitorAction> _monitorStream = StreamController();
  final ConnectionController _connectController = ConnectionController();
  final StreamController<Action> _carDirectionController =
      BehaviorSubject.seeded(Action.stop);
  final StreamController<bool> _deviceConnected = BehaviorSubject.seeded(false);
  @override
  Stream<LatLng> get coordinateData => _gpsController.coordinateStream;

  @override
  Stream<Action> get carDirectionStream => _carDirectionController.stream;

  @override
  Stream<bool> get deviceConnected => _deviceConnected.stream;

  late final MovingController _movingController;
  late final MonitorController _monitorController;
  late final GpsController _gpsController;
  @override
  Future<void> connectDevice(String address) async {
    await _connectController.connectDevice(address, onComplete: () {
      _movingController = MovingController(
          _movingStream, _connectController.connection, _carDirectionController)
        ..getController();
      _monitorController =
          MonitorController(_monitorStream, _connectController.connection)
            ..getController();
      _gpsController = GpsController(_connectController.connection)
        ..getController();
    }, connectionController: _deviceConnected);
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

  @override
  alert(bool onPressed) {
    onPressed
        ? _monitorStream.add(MonitorAction.alertOn)
        : _monitorStream.add(MonitorAction.alertOff);
  }
}
