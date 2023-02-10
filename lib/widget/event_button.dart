import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hc05/widget/settings_dialog.dart';
import 'package:provider/provider.dart';

import '../bl_viewmodel.dart';
import '../core/app_resources.dart';
import '../gen/assets.gen.dart';

class GroupEventButton extends StatelessWidget {
  const GroupEventButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 35.0, right: 35.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          EventButton(
            icon: Assets.icons.icHighVolume,
            holdEvent: (onPress) =>
                context.read<BluetoothViewmodel>().horn(onPress),
          ),
          const SizedBox(width: 10.0),
          EventButton(
            icon: Assets.icons.icWarning,
            holdEvent: (onPress) =>
                context.read<BluetoothViewmodel>().horn(onPress),
          ),
          const SizedBox(width: 10.0),
          EventButton(
            icon: Assets.icons.icGps,
            tapEvent: () {},
          ),
          const SizedBox(width: 10.0),
          EventButton(
            icon: Assets.icons.icSetting,
            tapEvent: () {
              context.read<BluetoothViewmodel>().startDiscover();
              showDialog(
                  context: context,
                  builder: (context) => const SettingsDialog());
            },
          ),
        ],
      ),
    );
  }
}

class EventButton extends StatelessWidget {
  const EventButton({
    Key? key,
    this.holdEvent,
    required this.icon,
    this.tapEvent,
    this.width,
    this.heigth,
  }) : super(key: key);
  final Function(bool)? holdEvent;
  final Function()? tapEvent;
  final String icon;
  final double? width;
  final double? heigth;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => tapEvent?.call(),
      onTapUp: (_) => holdEvent?.call(false),
      onTapDown: (_) => holdEvent?.call(true),
      child: Container(
        width: width ?? 60.0,
        height: heigth ?? 60.0,
        padding: const EdgeInsets.all(6.0),
        decoration:
            const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
        child: Container(
          decoration: const BoxDecoration(
              color: AppColors.charlestonGreen, shape: BoxShape.circle),
          child: Center(child: SvgPicture.asset(icon)),
        ),
      ),
    );
  }
}
