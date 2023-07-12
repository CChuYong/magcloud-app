import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/view/component/base_settings_layout.dart';

import '../../../core/framework/base_view.dart';
import '../../../core/util/i18n.dart';
import '../../../view_model/setting_view/notification_config_view_model.dart';
import '../../component/touchableopacity.dart';
import '../../designsystem/base_color.dart';

class NotificationConfigView extends BaseView<NotificationConfigView,
    NotificationConfigViewModel, NotificationConfigViewState> {
  NotificationConfigView({super.key});

  @override
  Widget render(BuildContext context, NotificationConfigViewModel action,
      NotificationConfigViewState state) {
    final gapBetweenBadge = 11.sp;
    return BaseSettingLayout(
      title: message('menu_notification'),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.sp),
            Row(
              children: [
                SizedBox(width: 8.sp),
                Text(message('generic_notification_list'),
                    style: TextStyle(
                        color: BaseColor.warmGray600, fontSize: 16.sp))
              ],
            ),
            SizedBox(height: 10.sp),
            notificationBox(
                message('generic_notification_friend'),
                message('message_notification_config_friend_info'),
                state.socialAlert,
                () => action.changeSetting('social', !state.socialAlert)),
            SizedBox(height: gapBetweenBadge),
            notificationBox(
                message('generic_notification_feed'),
                message('message_notification_feed'),
                state.feedAlert,
                () => action.changeSetting('feed', !state.feedAlert)),
            SizedBox(height: 11.sp),
            notificationBox(
                message('generic_notification_app'),
                message('message_notification_config_app_info'),
                state.noticeAlert,
                () => action.changeSetting('notice', !state.noticeAlert)),
            SizedBox(height: 11.sp),
            Row(
              children: [
                SizedBox(width: 8.sp),
                Flexible(
                    child: Text(message('message_notification_config_info'),
                        style: TextStyle(
                            color: BaseColor.warmGray500, fontSize: 12.sp))),
                SizedBox(width: 8.sp),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget notificationBox(
      String title, String subtitle, bool isSelected, void Function() onTap) {
    return TouchableOpacity(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: BaseColor.warmGray50,
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 20.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title,
                      style: TextStyle(
                          color: BaseColor.warmGray600, fontSize: 14.sp)),
                  Text(subtitle,
                      style: TextStyle(
                          color: BaseColor.warmGray500, fontSize: 12.sp))
                ]),
                Icon(Icons.check,
                    size: 20.sp,
                    color: isSelected
                        ? BaseColor.warmGray700
                        : BaseColor.warmGray300),
              ],
            ),
          ),
        ));
  }

  @override
  NotificationConfigViewModel initViewModel() => NotificationConfigViewModel();
}
