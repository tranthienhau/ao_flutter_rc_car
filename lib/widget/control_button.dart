import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../bl_viewmodel.dart';
import '../core/app_resources.dart';
import '../gen/assets.gen.dart';
import '../util/enum.dart';

class LeftRightDirection extends StatelessWidget {
  const LeftRightDirection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 64),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          _ControlButton(
            rotate: Rotate.left,
            direction: Direction.left,
          ),
          SizedBox(width: 30),
          _ControlButton(
            rotate: Rotate.right,
            direction: Direction.right,
          ),
        ],
      ),
    );
  }
}

class UpDownDirection extends StatelessWidget {
  const UpDownDirection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 115),
      child: Column(
        children: const [
          Spacer(),
          _ControlButton(
            rotate: Rotate.up,
            direction: Direction.forward,
          ),
          SizedBox(height: 30),
          _ControlButton(
            rotate: Rotate.down,
            direction: Direction.backward,
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton(
      {Key? key, required this.direction, this.rotate = Rotate.down})
      : super(key: key);
  final Direction direction;
  final Rotate rotate;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (_) => context.read<BluetoothViewmodel>().stop(direction),
      onTapDown: (_) => context.read<BluetoothViewmodel>().go(direction),
      child: Container(
        width: 95.0,
        height: 95.0,
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(width: 2, color: AppColors.graniteGray)),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(width: 4, color: Colors.black),
          ),
          child: Center(
              child: RotatedBox(
                  quarterTurns: rotate.index,
                  child: SvgPicture.asset(Assets.icons.icSortArrow))),
        ),
      ),
    );
  }
}

enum Rotate { down, left, up, right }
