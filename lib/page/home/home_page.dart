import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hc05/bl_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../core/app_resources.dart';
import '../../gen/assets.gen.dart';
import '../../widget/control_button.dart';
import '../../widget/control_table.dart';
import '../../widget/event_button.dart';
import '../../widget/rectangle_slider_tick_mark.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraint) {
          return Stack(
            children: [
              Opacity(
                opacity: 0.75,
                child: Image.asset(
                  Assets.icons.background.path,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              const FrostBackgroundEffect(),
              Positioned(
                child: const GroupEventButton(),
                bottom: constraint.minHeight * 0.1,
                right: constraint.minWidth * 0.8,
              ),
              const Align(alignment: Alignment.topLeft, child: _SpeedSlider()),
              const Positioned(child: UpDownDirection()),
              const Align(
                  alignment: Alignment.centerRight,
                  child: LeftRightDirection()),
              Positioned(
                  top: constraint.maxHeight * 0.23,
                  left: constraint.maxWidth * 0.32,
                  child: const ControlTable()),
              const Align(alignment: Alignment.topRight, child: _CarLed())
            ],
          );
        }),
      ),
    );
  }
}

class FrostBackgroundEffect extends StatelessWidget {
  const FrostBackgroundEffect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: AppColors.eerieBlack.withOpacity(0.6)),
      ),
    );
  }
}

class _SpeedSlider extends StatefulWidget {
  const _SpeedSlider({Key? key}) : super(key: key);

  @override
  State<_SpeedSlider> createState() => _SpeedSliderState();
}

class _SpeedSliderState extends State<_SpeedSlider> {
  double _value = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
      child: RotatedBox(
        quarterTurns: 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                RotatedBox(
                  quarterTurns: 3,
                  child: EventButton(
                      icon: Assets.icons.icMinus, width: 50.0, heigth: 50.0),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.white30,
                      trackHeight: 1.0,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      thumbColor: Colors.white,
                      tickMarkShape: const RectangleSliderTickMarkShape(),
                      activeTickMarkColor: Colors.white,
                      inactiveTickMarkColor: Colors.white30,
                      valueIndicatorShape:
                          const PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor: Colors.white,
                      valueIndicatorTextStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    child: Slider(
                      value: _value,
                      min: 0,
                      max: 100,
                      divisions: 10,
                      label: (_value / 10).toStringAsFixed(0),
                      onChanged: (value) {
                        setState(
                          () {
                            _value = value;
                          },
                        );
                      },
                    ),
                  ),
                ),
                RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    _value.toStringAsFixed(0),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                EventButton(
                  icon: Assets.icons.icPlus,
                  width: 50.0,
                  heigth: 50.0,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _CarLed extends StatelessWidget {
  const _CarLed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 60,
      margin: const EdgeInsets.only(right: 30, top: 15),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _CarLedPart(
            icon: Assets.icons.icCarHead,
            callback: (isActivate) =>
                context.read<BluetoothViewmodel>().frontLight(isActivate),
          ),
          const SizedBox(width: 4),
          _CarLedPart(
            icon: Assets.icons.icCarTail,
            callback: (isActivate) =>
                context.read<BluetoothViewmodel>().backLight(isActivate),
          )
        ],
      ),
    );
  }
}

class _CarLedPart extends StatefulWidget {
  const _CarLedPart({Key? key, required this.icon, required this.callback})
      : super(key: key);
  final String icon;
  final Function(bool) callback;
  @override
  State<_CarLedPart> createState() => _CarLedPartState();
}

class _CarLedPartState extends State<_CarLedPart> {
  bool isActivate = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: AppColors.charlestonGreen,
          borderRadius: BorderRadius.circular(10)),
      child: InkWell(
          onTap: () {
            setState(() {
              isActivate = !isActivate;
            });
            widget.callback.call(isActivate);
          },
          child: SvgPicture.asset(
            widget.icon,
            color: isActivate ? Colors.white : Colors.white24,
          )),
    );
  }
}
