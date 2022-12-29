import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

abstract class CarController {
  Future startDiscover(Function(BluetoothDiscoveryResult result)? onDiscover);
  Future<bool?> connectDevice(String address);
}

class CarControllerImpl extends CarController {
  CarControllerImpl(this.controller);
  final StreamController<Map<String, bool>> controller;
  late StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<Direction> directionState = [];

  BluetoothConnection? _connection;
  List<BluetoothDiscoveryResult> results = [];
  @override
  Future startDiscover(Function(BluetoothDiscoveryResult)? onDiscover) async {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
      final duplicate = results.indexWhere(
          (element) => element.device.address == result.device.address);
      if (duplicate >= 0) {
        results[duplicate] = result;
      } else {
        log(result.device.address);
        results = [...results, result];
        onDiscover?.call(result);
      }
    });
  }

  @override
  Future<bool?> connectDevice(String address) async {
    BluetoothConnection.toAddress(address).then((connection) {
      _connection = connection;
    }).whenComplete(() {
      _stop();
      _listenToDirection();
    });

    return true;
  }

  Action? _currentState(String state, bool isAdd) {
    Direction direction = Direction.values.byName(state);
    return isAdd ? _addState(direction) : _removeSate(direction);
  }

  Action _atomicState() {
    var action = Action.stop;
    var state = directionState.single;
    switch (state) {
      case Direction.forward:
        action = Action.goUp;
        break;
      case Direction.backward:
        action = Action.goDown;
        break;
      case Direction.left:
        action = Action.goLeft;
        break;
      case Direction.right:
        action = Action.goRight;
        break;
    }
    return action;
  }

  Action? _combineState() {
    if (directionState.contains(Direction.forward) &&
        (directionState.contains(Direction.backward))) {
      return null;
    } else if (directionState.contains(Direction.left) &&
        (directionState.contains(Direction.right))) {
      return null;
    }
    if (directionState.contains(Direction.forward)) {
      return (directionState.contains(Direction.left) == true)
          ? Action.goUpLeft
          : Action.goUpRight;
    } else if (directionState.contains(Direction.backward)) {
      return (directionState.contains(Direction.left) == true)
          ? Action.goDownRight
          : Action.goDownLeft;
    }
    return null;
  }

  Action? _addState(Direction state) {
    var carState = CarState.values[directionState.length];
    switch (carState) {
      case CarState.Empty:
        directionState.add(state);
        return _atomicState();
      case CarState.Atomic:
        directionState.add(state);
        return _combineState();
      case CarState.Combine:
        return null;
    }
  }

  Action? _removeSate(Direction state) {
    var carState = CarState.values[directionState.length];
    switch (carState) {
      case CarState.Empty:
        return null;
      case CarState.Atomic:
        directionState.remove(state);
        return Action.stop;
      case CarState.Combine:
        directionState.remove(state);
        return _atomicState();
      default:
        return null;
    }
  }

  _listenToDirection() {
    controller.stream.listen((event) {
      Action? action = _currentState(event.keys.first, event.values.first);
      switch (action) {
        case Action.goUp:
          _up();
          break;
        case Action.goDown:
          _down();
          break;
        case Action.goLeft:
          _left();
          break;
        case Action.goRight:
          _right();
          break;
        case Action.stop:
          _stop();
          break;
        case Action.goUpLeft:
          _upLeft();
          break;
        case Action.goUpRight:
          _upRight();
          break;
        case Action.goDownLeft:
          _downLeft(); // TODO: Handle this case.
          break;
        case Action.goDownRight:
          _downRight();
          break;
        case null:
          _stop();
          break;
      }
    });
  }

  _up() async {
    _connection?.output.add(Uint8List.fromList(utf8.encode('F\r\n')));
    await _connection?.output.allSent;
  }

  _upLeft() async {
    _connection?.output.add(Uint8List.fromList(utf8.encode('G\r\n')));
    await _connection?.output.allSent;
  }

  _upRight() async {
    _connection?.output.add(Uint8List.fromList(utf8.encode('I\r\n')));
    await _connection?.output.allSent;
  }

  _stop() async {
    _connection?.output.add(Uint8List.fromList(utf8.encode('S\r\n')));
    await _connection?.output.allSent;
  }

  _down() async {
    _connection?.output.add(Uint8List.fromList(utf8.encode('B\r\n')));
    await _connection?.output.allSent;
  }

  _downLeft() async {
    _connection?.output.add(Uint8List.fromList(utf8.encode('J\r\n')));
    await _connection?.output.allSent;
  }

  _downRight() async {
    _connection?.output.add(Uint8List.fromList(utf8.encode('H\r\n')));
    await _connection?.output.allSent;
  }

  _left() async {
    _connection?.output.add(Uint8List.fromList(utf8.encode('L\r\n')));
    await _connection?.output.allSent;
  }

  _right() async {
    _connection?.output.add(Uint8List.fromList(utf8.encode('R\r\n')));
    await _connection?.output.allSent;
  }
}

enum CarState { Empty, Atomic, Combine }

enum Direction { forward, backward, left, right }

enum Action {
  goUp,
  goDown,
  goLeft,
  goRight,
  goUpLeft,
  goUpRight,
  goDownLeft,
  goDownRight,
  stop
}
