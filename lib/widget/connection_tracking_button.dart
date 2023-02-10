import 'package:flutter/material.dart';

class ConnectionTrackingButton extends StatefulWidget {
  const ConnectionTrackingButton({Key? key, required this.blinkingColor})
      : super(key: key);
  final Color blinkingColor;
  @override
  State<ConnectionTrackingButton> createState() =>
      _ConnectionTrackingButtonState();
}

class _ConnectionTrackingButtonState extends State<ConnectionTrackingButton>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> animation;
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.linear);
    animation = ColorTween(begin: Colors.transparent, end: widget.blinkingColor)
        .animate(curve);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
      setState(() {});
    });
    // Remove this line if you want to start the animation later
    controller.forward();
  }

  @override
  void didUpdateWidget(covariant ConnectionTrackingButton oldWidget) {
    if (oldWidget.blinkingColor != widget.blinkingColor) {
      animation = ColorTween(
              begin: Colors.transparent, end: widget.blinkingColor)
          .animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Container(
        width: 50,
        height: 50,
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black)]),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF131313),
              boxShadow: [
                BoxShadow(color: Colors.white, blurRadius: 3, spreadRadius: 1)
              ]),
          child: Container(
            decoration:
                BoxDecoration(color: animation.value, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
