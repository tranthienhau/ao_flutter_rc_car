import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hc05/core/app_resources.dart';
import 'package:provider/provider.dart';

import '../bl_viewmodel.dart';
import 'bluetooth_device_list_entry.dart';
import '../gen/assets.gen.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 320,
              height: 280,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.charlestonGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _buildListDevice(),
              ),
            ),
            Positioned(
                top: -25,
                right: -25,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.charlestonGreen),
                      child: SvgPicture.asset(Assets.icons.icClose)),
                )),
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
}
