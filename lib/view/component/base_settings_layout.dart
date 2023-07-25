import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:magcloud_app/global_routes.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';
import 'package:magcloud_app/view/designsystem/base_icon.dart';

import '../designsystem/base_color.dart';

class BaseSettingLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const BaseSettingLayout(
      {super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [titleBar(context), Expanded(child: child)],
        ),
      ),
    );
  }

  Widget titleBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 31.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TouchableOpacity(
            onTap: GlobalRoute.back,
            child: SizedBox(
                width: 47.sp,
                height: 32.sp,
                child: Align(
                    alignment: Alignment.center,
                    child: Icon(BaseIcon.arrowLeft, size: 16.sp, color: context.theme.colorScheme.secondary))),
          ),
          Text(title,
              style: TextStyle(
                  color: context.theme.colorScheme.primary,
                  fontSize: 16.sp,
                  fontFamily: 'Pretendard')),
          SizedBox(width: 16.sp, height: 16.sp),
        ],
      ),
    );
  }
}
