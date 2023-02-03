import 'package:get_it/get_it.dart';
import 'package:hc05/bl_viewmodel.dart';
import 'package:hc05/service/car_service.dart';
import 'package:hc05/service/navigation_service.dart';

GetIt locator = GetIt.instance;
Future setupLocator() async {
  _setupService();
  _setupViewModel();
}

void _setupViewModel() {
  locator.registerLazySingleton<BluetoothViewmodel>(
      () => BluetoothViewmodel(locator()));
}

void _setupService() {
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<CarService>(() => CarServiceImpl());
}
