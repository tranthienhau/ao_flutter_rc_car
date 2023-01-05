import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class MonitorController {
  MonitorController(
    this._monitorController,
    this._connection,
  );
  final BluetoothConnection? _connection;
  getController() {
    _onMonitorAction();
  }

  final StreamController<MonitorAction> _monitorController;
  _onMonitorAction() {
    _monitorController.stream.listen((action) {
      switch (action) {
        case MonitorAction.hornOn:
          _hornOn();
          break;
        case MonitorAction.hornOff:
          _hornOff();
          break;
        case MonitorAction.frontLightsOn:
          _frontLightsOn();
          break;
        case MonitorAction.frontLightsOff:
          _frontLightsOff();
          break;
        case MonitorAction.backLightsOn:
          _backLightsOn();
          break;
        case MonitorAction.backLightsOff:
          _backLightsOff();
          break;
      }
    });
  }

  setSpeed(Speed speed) {
    _connection?.output.add(speed.transformSpeed());
  }

  _hornOn() async {
    _connection?.output.add(Uint8List.fromList(utf8.encode('V\r\n')));
    await _connection?.output.allSent;
  }

  _hornOff() async {
    _connection?.output.add(Uint8List.fromList(utf8.encode('v\r\n')));
    await _connection?.output.allSent;
  }

  _frontLightsOn() async {
    _connection?.output.add(Uint8List.fromList(utf8.encode('W\r\n')));
    await _connection?.output.allSent;
  }

  _frontLightsOff() async {
    _connection?.output.add(Uint8List.fromList(utf8.encode('w\r\n')));
    await _connection?.output.allSent;
  }

  _backLightsOn() async {
    _connection?.output.add(Uint8List.fromList(utf8.encode('U\r\n')));
    await _connection?.output.allSent;
  }

  _backLightsOff() async {
    _connection?.output.add(Uint8List.fromList(utf8.encode('u\r\n')));
    await _connection?.output.allSent;
  }
}

enum MonitorAction {
  hornOn,
  hornOff,
  frontLightsOn,
  frontLightsOff,
  backLightsOn,
  backLightsOff,
}

enum Speed {
  speed_0,
  speed_10,
  speed_20,
  speed_30,
  speed_40,
  speed_50,
  speed_60,
  speed_70,
  speed_80,
  speed_90,
  speed_100,
}

extension SpeedExtension on Speed {
  Uint8List transformSpeed() {
    var speed = name.split('_').last;
    var speedLevel = (int.parse(speed) ~/ 10).toString();
    return Uint8List.fromList(
        utf8.encode('${speedLevel != '10' ? speedLevel : 'q'}\r\n'));
  }
}
