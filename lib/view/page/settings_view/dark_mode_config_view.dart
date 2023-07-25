import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:magcloud_app/view/component/base_settings_layout.dart';

import '../../../core/framework/base_view.dart';
import '../../../core/util/i18n.dart';
import '../../../view_model/setting_view/dark_mode_config_view_model.dart';
import '../../../view_model/setting_view/notification_config_view_model.dart';
import '../../component/touchableopacity.dart';
import '../../designsystem/base_color.dart';

class DarkModeConfigView extends BaseView<DarkModeConfigView,
    DarkModeConfigViewModel, DarkModeConfigViewState> {
  DarkModeConfigView({super.key});

  @override
  Widget render(BuildContext context, DarkModeConfigViewModel action,
      DarkModeConfigViewState state) {
    final gapBetweenBadge = 11.sp;
    return BaseSettingLayout(
      title: message('menu_dark_mode'),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.sp),
            Row(
              children: [
                SizedBox(width: 8.sp),
                Text(message('generic_dark_mode_list'),
                    style: TextStyle(
                        color: context.theme.colorScheme.primary, fontSize: 16.sp))
              ],
            ),
            SizedBox(height: 10.sp),
            notificationBox(
              context,
                message('generic_dark_mode_system_setting'),
                message('generic_dark_mode_system_setting_description'),
                action.currentThemeMode() == ThemeMode.system,
                () => action.changeSetting(ThemeMode.system)),
            SizedBox(height: gapBetweenBadge),
            notificationBox(
                context,
                message('generic_dark_mode_dark'),
                message('generic_dark_mode_dark_description'),
                action.currentThemeMode() == ThemeMode.dark,
                () => action.changeSetting(ThemeMode.dark)),
            SizedBox(height: 11.sp),
            notificationBox(
                context,
                message('generic_dark_mode_light'),
                message('generic_dark_mode_light_description'),
                action.currentThemeMode() == ThemeMode.light,
                () => action.changeSetting(ThemeMode.light)),
            SizedBox(height: 11.sp),
            Row(
              children: [
                SizedBox(width: 8.sp),
                Flexible(
                    child: Text(message('message_dark_mode_settings_info'),
                        style: TextStyle(
                            color: context.theme.colorScheme.secondary, fontSize: 12.sp))),
                SizedBox(width: 8.sp),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget notificationBox(
      BuildContext context,
      String title, String subtitle, bool isSelected, void Function() onTap) {
    return TouchableOpacity(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: context.theme.colorScheme.onBackground,
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 20.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title,
                      style: TextStyle(
                          color: context.theme.colorScheme.primary, fontSize: 14.sp)),
                  Text(subtitle,
                      style: TextStyle(
                          color: context.theme.colorScheme.secondary, fontSize: 12.sp))
                ]),
                Icon(Icons.check,
                    size: 20.sp,
                    color: isSelected
                        ? context.theme.colorScheme.primary
                        : context.theme.colorScheme.outlineVariant),
              ],
            ),
          ),
        ));
  }

  @override
  DarkModeConfigViewModel initViewModel() => DarkModeConfigViewModel();
}
