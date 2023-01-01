import 'package:get_it/get_it.dart';
import 'package:hc05/bl_viewmodel.dart';

GetIt locator = GetIt.instance;
Future setupLocator() async {
  _setupViewModel();
}

void _setupViewModel() {
  locator.registerLazySingleton<BluetoothViewmodel>(() => BluetoothViewmodel());
}
