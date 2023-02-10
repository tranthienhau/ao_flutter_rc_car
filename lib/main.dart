import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hc05/page/app.dart';
import 'package:hc05/setup.dart';

void main() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((value) => runApp(const MyApp()));
}
