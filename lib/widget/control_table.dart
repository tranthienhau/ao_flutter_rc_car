import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../bl_viewmodel.dart';
import '../core/app_resources.dart';
import '../gen/assets.gen.dart';
import '../util/enum.dart' as en;
import 'connection_tracking_button.dart';

class ControlTable extends StatelessWidget {
  const ControlTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<en.Action>(
      stream: context.read<BluetoothViewmodel>().carDirectionStream,
      builder: (context, snapshot) {
        return Container(
          width: 220,
          height: 220,
          margin: const EdgeInsets.only(right: 50),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color(0xFF010101),
              borderRadius: BorderRadius.circular(10)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: const Color(0xFF131313),
                borderRadius: BorderRadius.circular(10)),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _DirectionArrow(
                          isActive: (snapshot.data ?? en.Action.stop) ==
                              en.Action.goUpLeft,
                          direction: en.Action.goUpLeft,
                        ),
                        _DirectionArrow(
                          isActive: (snapshot.data ?? en.Action.stop) ==
                              en.Action.goUp,
                          direction: en.Action.goUp,
                        ),
                        _DirectionArrow(
                          isActive: (snapshot.data ?? en.Action.stop) ==
                              en.Action.goUpRight,
                          direction: en.Action.goUpRight,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _DirectionArrow(
                          isActive: (snapshot.data ?? en.Action.stop) ==
                              en.Action.goLeft,
                          direction: en.Action.goLeft,
                        ),
                        _DirectionArrow(
                          isActive: (snapshot.data ?? en.Action.stop) ==
                              en.Action.goRight,
                          direction: en.Action.goRight,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _DirectionArrow(
                          isActive: (snapshot.data ?? en.Action.stop) ==
                              en.Action.goDownLeft,
                          direction: en.Action.goDownLeft,
                        ),
                        _DirectionArrow(
                          isActive: (snapshot.data ?? en.Action.stop) ==
                              en.Action.goDown,
                          direction: en.Action.goDown,
                        ),
                        _DirectionArrow(
                          isActive: (snapshot.data ?? en.Action.stop) ==
                              en.Action.goDownRight,
                          direction: en.Action.goDownRight,
                        )
                      ],
                    )
                  ],
                ),
                Center(
                  child: StreamBuilder<bool>(
                      stream:
                          context.read<BluetoothViewmodel>().deviceConnected,
                      builder: (context, snapshot) {
                        var blinkingColor = snapshot.data == true
                            ? AppColors.neonGreen
                            : AppColors.lust;
                        return ConnectionTrackingButton(
                          blinkingColor: blinkingColor,
                        );
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DirectionArrow extends StatelessWidget {
  const _DirectionArrow({
    Key? key,
    required this.direction,
    required this.isActive,
  }) : super(key: key);
  final en.Action direction;
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: direction.index * math.pi / 4,
      child: SvgPicture.asset(
        Assets.icons.icArrow,
        color: isActive ? AppColors.neonGreen : null,
      ),
    );
  }
}
