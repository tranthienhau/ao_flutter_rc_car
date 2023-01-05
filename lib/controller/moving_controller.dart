import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class MovingController {
  MovingController(this._controller, this._connection);
  final StreamController<Map<String, bool>> _controller;
  final List<Direction> _directionState = [];
  final BluetoothConnection? _connection;

  getController() {
    _stop();
    _onDirectionChanged();
  }

  Action? _currentDirection(String state, bool isAdd) {
    Direction direction = Direction.values.byName(state);
    return isAdd ? _addDirection(direction) : _removeDirection(direction);
  }

  Action _atomicDirection() {
    var action = Action.stop;
    var state = _directionState.single;
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

  Action? _combineDirection() {
    if (_directionState.contains(Direction.forward) &&
        (_directionState.contains(Direction.backward))) {
      return null;
    } else if (_directionState.contains(Direction.left) &&
        (_directionState.contains(Direction.right))) {
      return null;
    }
    if (_directionState.contains(Direction.forward)) {
      return (_directionState.contains(Direction.left) == true)
          ? Action.goUpLeft
          : Action.goUpRight;
    } else if (_directionState.contains(Direction.backward)) {
      return (_directionState.contains(Direction.left) == true)
          ? Action.goDownLeft
          : Action.goDownRight;
    }
    return null;
  }

  Action? _addDirection(Direction state) {
    var carState = CarState.values[_directionState.length];
    switch (carState) {
      case CarState.empty:
        _directionState.add(state);
        return _atomicDirection();
      case CarState.atomic:
        _directionState.add(state);
        return _combineDirection();
      case CarState.combine:
        return null;
    }
  }

  Action? _removeDirection(Direction state) {
    var carState = CarState.values[_directionState.length];
    switch (carState) {
      case CarState.empty:
        return null;
      case CarState.atomic:
        _directionState.remove(state);
        return Action.stop;
      case CarState.combine:
        _directionState.remove(state);
        return _atomicDirection();
      default:
        return null;
    }
  }

  _onDirectionChanged() {
    _controller.stream.listen((event) {
      Action? action = _currentDirection(event.keys.first, event.values.first);
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
          _downLeft();
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
    _connection?.output.add(Uint8List.fromList(utf8.encode('H\r\n')));
    await _connection?.output.allSent;
  }

  _downRight() async {
    _connection?.output.add(Uint8List.fromList(utf8.encode('J\r\n')));
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

enum CarState { empty, atomic, combine }

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
