import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:hc05/bl_viewmodel.dart';
import 'package:hc05/setup.dart';
import 'package:provider/provider.dart';

import 'bluetooth_device_list_entry.dart';
import 'controller/monitor_controller.dart';
import 'controller/moving_controller.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

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
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth'),
        actions: [
          GestureDetector(
              onTapUp: (_) => context.read<BluetoothViewmodel>().horn(false),
              onTapDown: (_) => context.read<BluetoothViewmodel>().horn(true),
              child:
                  const Icon(Icons.ring_volume, size: 24, color: Colors.white)),
          const SizedBox(width: 20),
          GestureDetector(
              onTapUp: (_) =>
                  context.read<BluetoothViewmodel>().frontLight(false),
              onTapDown: (_) =>
                  context.read<BluetoothViewmodel>().frontLight(true),
              child: const Icon(Icons.light, size: 24, color: Colors.white)),
          const SizedBox(width: 20),
          GestureDetector(
              onTapUp: (_) =>
                  context.read<BluetoothViewmodel>().backLight(false),
              onTapDown: (_) =>
                  context.read<BluetoothViewmodel>().backLight(true),
              child: const Icon(Icons.light, size: 24, color: Colors.white)),
          const SizedBox(width: 20),
          InkWell(
              onTap: () {
                context.read<BluetoothViewmodel>().startDiscover();
              },
              child: const Icon(Icons.scanner, size: 24, color: Colors.white)),
          const SizedBox(width: 20),
          PopupMenuButton<String>(
            onSelected: (value) => handleClick(context, value),
            itemBuilder: (BuildContext context) {
              return Speed.values.map((Speed speed) {
                return PopupMenuItem<String>(
                  value: speed.name,
                  child: Text(speed.name),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildControlButton(
                    context,
                    Icons.arrow_left,
                    Direction.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildControlButton(
                    context,
                    Icons.arrow_upward,
                    Direction.forward,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildControlButton(
                    context,
                    Icons.arrow_downward,
                    Direction.backward,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildControlButton(
                    context,
                    Icons.arrow_right,
                    Direction.right,
                  ),
                ),
              ],
            ),
            Expanded(
              child: _buildListDevice(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListDevice() {
    return Selector<BluetoothViewmodel, List<BluetoothDiscoveryResult>>(
      builder: (context, results, child) {
        return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              var device = results[index].device;
              final address = device.address;
              BluetoothDiscoveryResult result = results[index];
              return BluetoothDeviceListEntry(
                device: device,
                rssi: result.rssi,
                onTap: () {
                  context.read<BluetoothViewmodel>().connectDevice(address);
                },
              );
            });
      },
      selector: (context, vm) => vm.results,
    );
  }

  Widget _buildControlButton(
      BuildContext context, IconData icon, Direction direction) {
    return GestureDetector(
      onTapUp: (_) => context.read<BluetoothViewmodel>().stop(direction),
      onTapDown: (_) => context.read<BluetoothViewmodel>().go(direction),
      child: Icon(icon, size: 40),
    );
  }

  handleClick(BuildContext context, String value) {
    Speed speed = Speed.values.byName(value);
    context.read<BluetoothViewmodel>().setSpeed(speed);
  }
}
