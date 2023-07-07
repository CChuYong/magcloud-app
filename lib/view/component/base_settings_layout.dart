import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      backgroundColor: BaseColor.defaultBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [titleBar(), Expanded(child: child)],
        ),
      ),
    );
  }

  Widget titleBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TouchableOpacity(
              onTap: GlobalRoute.back,
              child: Icon(BaseIcon.arrowLeft, size: 16.sp)),
          Text(title,
              style: TextStyle(
                  color: BaseColor.warmGray600,
                  fontSize: 16.sp,
                  fontFamily: 'GmarketSans')),
          SizedBox(width: 16.sp, height: 16.sp),
        ],
      ),
    );
  }
}
