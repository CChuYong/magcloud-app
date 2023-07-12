import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';
import 'package:rainbow_color/rainbow_color.dart';

import '../../core/util/i18n.dart';

class SplashOverlay extends StatefulWidget {
  const SplashOverlay({super.key});

  @override
  State createState() => _SplashViewState();
}

class _SplashViewState extends State with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Color> _colorAnim;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    _colorAnim = RainbowColorTween([
      BaseColor.warmGray400,
      BaseColor.warmGray500,
      BaseColor.warmGray600,
      BaseColor.warmGray700,
      BaseColor.warmGray600,
      BaseColor.warmGray500,
      BaseColor.warmGray400,
    ]).animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
          controller.forward();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Text(
              message("magcloud"),
              style: TextStyle(
                  color: _colorAnim.value,
                  fontSize: 30.sp,
                  fontFamily: 'GmarketSans'),
            ),
          ),
        ));
  }
}
