import 'package:flutter/material.dart';
import 'package:hc05/page/map/map.dart';

import '../page/home/home_page.dart';

class AppRoute {
  static const pageMap = "/map";

  static Route<Object>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case pageMap:
        return MaterialPageRoute(
          builder: (_) => const MapSample(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );
    }
  }
}
