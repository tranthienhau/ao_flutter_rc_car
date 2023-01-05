import 'package:get_it/get_it.dart';
import 'package:hc05/bl_viewmodel.dart';
import 'package:hc05/controller/car_service.dart';

GetIt locator = GetIt.instance;
Future setupLocator() async {
  locator.registerLazySingleton<CarService>(() => CarServiceImpl());
  _setupViewModel();
}

void _setupViewModel() {
  locator.registerLazySingleton<BluetoothViewmodel>(
      () => BluetoothViewmodel(locator()));
}
