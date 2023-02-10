import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../bl_viewmodel.dart';
import '../core/app_router.dart';
import '../service/navigation_service.dart';
import '../setup.dart';
import 'home/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BluetoothViewmodel>.value(
          value: locator.get<BluetoothViewmodel>(),
        )
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          onGenerateRoute: AppRoute.generateRoute,
          initialRoute: '/',
          navigatorKey: globalNavigationKey,
          home: const HomePage(),
        ),
      ),
    );
  }
}
