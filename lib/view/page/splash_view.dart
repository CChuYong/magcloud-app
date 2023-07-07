import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';
import 'package:rainbow_color/rainbow_color.dart';

import '../../core/util/i18n.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State createState() => _SplashViewState();
}

class _SplashViewState extends State with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<Color> _colorAnim;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(milliseconds: 1500), vsync: this);
    _colorAnim = RainbowColorTween([
      BaseColor.warmGray300,
      BaseColor.warmGray500,
      BaseColor.warmGray700,
      BaseColor.warmGray500,
      BaseColor.warmGray300,
    ])
        .animate(controller)
      ..addListener(() { setState(() {}); })
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColor.defaultSplashBackgroundColor,
      body: Container(
        width: double.infinity,
          height: double.infinity,
        child: Center(
          child:    Text(
            message("magcloud"),
            style: TextStyle(
                color: _colorAnim.value,
                fontSize: 30.sp,
                fontFamily: 'GmarketSans'),
          ),
        ),
      )
    );
  }
}
