import 'package:flutter/material.dart';

class TouchableOpacity extends StatefulWidget {
  final Widget child;
  final void Function()? onTap;
  final Duration opacityDuration = const Duration(milliseconds: 150);
  final Duration scaleDuration = const Duration(milliseconds: 100);
  final double opacity = 0.5;
  final double scale = 0.98;

  const TouchableOpacity({super.key, required this.child, this.onTap});

  @override
  State createState() => _TouchableOpacityState();
}

class _TouchableOpacityState extends State<TouchableOpacity> {
  late bool isDown;

  @override
  void initState() {
    super.initState();
    setState(() => isDown = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (_) => setState(() => isDown = true),
        onTapUp: (_) => setState(() => isDown = false),
        onTapCancel: () => setState(() => isDown = false),
        onTap: widget.onTap,
        child: AnimatedScale(
            scale: isDown ? widget.scale : 1.0,
            duration: widget.scaleDuration,
            child: AnimatedOpacity(
              duration: widget.opacityDuration,
              opacity: isDown ? widget.opacity : 1,
              child: widget.child,
            )));
  }
}
