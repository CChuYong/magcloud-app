import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';
import 'package:magcloud_app/view/designsystem/base_icon.dart';
import 'package:magcloud_app/view_model/more_view/more_view_model.dart';
import 'package:magcloud_app/view_model/more_view/more_view_state.dart';

import '../../core/util/i18n.dart';
import '../component/navigation_bar.dart';
import '../designsystem/base_color.dart';

class MoreView extends BaseView<MoreView, MoreViewModel, MoreViewState> {
  const MoreView({super.key});

  @override
  MoreViewModel initViewModel() => MoreViewModel();

  @override
  Widget render(
      BuildContext context, MoreViewModel action, MoreViewState state) {
    return Scaffold(
      backgroundColor: BaseColor.defaultBackgroundColor,
      bottomNavigationBar: BaseNavigationBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [titleBar(),
            Expanded(child:  menuBox(action))
          ],
        ),
      ),
    );
  }

  Widget titleBar() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              message('navigation_more'),
              style: TextStyle(
                  color: BaseColor.warmGray800,
                  fontSize: 22.sp,
                  fontFamily: 'GmarketSans'),
            ),
          ],
        ));
  }

  Widget menuBox( MoreViewModel action) {
    final boxGap = 10.sp;
    return Padding(padding: EdgeInsets.symmetric(horizontal: 20.sp),
    child:
    SingleChildScrollView(
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.sp),
          Text(
            message('menu_settings'),
            style: TextStyle(
                color: BaseColor.warmGray500,
                fontSize: 20.sp,
                fontFamily: 'GmarketSans'),
          ),
          SizedBox(height: boxGap),
          menuBtn(Icons.person, message('menu_my_profiles'), action.onTapMyProfiles),
          SizedBox(height: boxGap),
          menuBtn(Icons.notifications, message('menu_notification'), action.onTapNotification),
          SizedBox(height: boxGap),
          menuBtn(Icons.font_download, message('menu_fonts'), action.onTapFonts),
          SizedBox(height: boxGap),
          menuBtn(Icons.language, message('menu_language'), action.onTapLanguage),
          SizedBox(height: 16.sp),
          Text(
            message('menu_info'),
            style: TextStyle(
                color: BaseColor.warmGray500,
                fontSize: 20.sp,
                fontFamily: 'GmarketSans'),
          ),
          SizedBox(height: boxGap),
          menuBtn(Icons.newspaper_outlined, message('menu_notice'), action.onTapNotice),
          SizedBox(height: boxGap),
          menuBtn(Icons.file_copy_rounded, message('menu_privacy'), action.onTapPrivacy),
          SizedBox(height: boxGap),
          menuBtn(Icons.phone_android, message('menu_app_info'), action.onTapAppInfo),
          SizedBox(height: boxGap),
          menuBtn(Icons.logout, message('menu_logout'), action.logout),
        ],
      ),
    )

      );
  }

  Widget menuBtn(IconData icon, String name, void Function() onTap) {
    return TouchableOpacity(
        onTap: onTap,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 24.sp,
                      width: 24.sp,
                      child: Center(child: Icon(icon, size: 24.sp, color: BaseColor.warmGray500)),
                    ),
                    SizedBox(width: 10.sp),
                    Text(
                      name,
                      style: TextStyle(
                          color: BaseColor.warmGray500,
                          fontSize: 16.sp,
                          height: 1.2,
                          fontFamily: 'GmarketSans'),
                    ),
                  ],
                ),
                Icon(BaseIcon.arrowRight, color: BaseColor.warmGray500)
              ],
            )));
  }
}
