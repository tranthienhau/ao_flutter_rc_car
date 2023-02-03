import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hc05/service/car_service.dart';

import 'controller/monitor_controller.dart';
import 'controller/moving_controller.dart';

class BluetoothViewmodel extends ChangeNotifier {
  BluetoothViewmodel(this.service);
  final CarService service;
  List<BluetoothDiscoveryResult> results = [];
  // List<LatLng> _latlngs = const [
  //   LatLng(-35.016, 143.321),
  //   LatLng(-34.747, 145.592),
  //   LatLng(-34.364, 147.891),
  //   LatLng(-33.501, 150.217),
  //   LatLng(-32.306, 149.248),
  //   LatLng(-32.491, 147.309)
  // ];
  List<LatLng> _latlngs = [];
  Set<Polyline> polylines = {};
  go(Direction direction) {
    service.go(direction);
  }

  stop(Direction direction) {
    service.stop(direction);
  }

  connectDevice(String address) async {
    await service.connectDevice(address);
    service.coordinateData.listen((latlng) {
      _latlngs = [..._latlngs, latlng];
      polylines = <Polyline>{}..add(
          Polyline(
            polylineId: const PolylineId("1"),
            points: _latlngs,
            color: Colors.orange,
            width: 2,
          ),
        );
      notifyListeners();
    });
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
