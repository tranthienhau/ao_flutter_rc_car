import 'dart:async';
import 'dart:convert';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GpsController {
  GpsController(this._connection);
  final BluetoothConnection? _connection;
  final StreamController<LatLng> _coordinates = StreamController.broadcast();
  Stream<LatLng> get coordinateStream => _coordinates.stream;
  getController() {
    _onGpsDataReceive();
  }

  _onGpsDataReceive() {
    _connection?.input?.listen((data) {
      var decodeData = ascii.decode(data);
      if (decodeData.contains(DataReg.latlng.regex) == true) {
        processCoordinateData(decodeData);
      }
    });
  }

  void processCoordinateData(String decodeData) {
    var rawCoordinate =
        DataReg.latlng.regex.stringMatch(decodeData)?.replaceAll(';', '');
    if (rawCoordinate != null) {
      var latitude = double.parse(rawCoordinate.split(',').first);
      var longitude = double.parse(rawCoordinate.split(',').last);
      _coordinates.add(LatLng(latitude, longitude));
    }
  }
}

class DataReg {
  const DataReg._internal(this.regex);
  final RegExp regex;
  static const String _doubleReg = r"[+-]?\d*\.?\d+";
  static DataReg invalid = DataReg._internal(RegExp(r"(INVALID;)+?"));
  static DataReg none = DataReg._internal(RegExp(r"(NONE;)+?"));
  static DataReg latlng =
      DataReg._internal(RegExp("($_doubleReg,$_doubleReg;)+?"));
}
