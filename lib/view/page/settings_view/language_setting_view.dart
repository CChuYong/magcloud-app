import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/view/component/fadeable_switcher.dart';

import '../../../view_model/setting_view/language_setting_view_model.dart';
import '../../component/base_settings_layout.dart';
import '../../component/touchableopacity.dart';
import '../../designsystem/base_color.dart';

class LanguageSettingView extends BaseView<LanguageSettingView,
    LanguageSettingViewModel, LanguageSettingViewState> {
  @override
  LanguageSettingViewModel initViewModel() => LanguageSettingViewModel();

  @override
  Widget render(BuildContext context, LanguageSettingViewModel action,
      LanguageSettingViewState state) {
    return Fadeable(
        child: BaseSettingLayout(
      key: Key(isKorea.toString()),
      title: message('menu_language'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.sp),
          Row(
            children: [
              SizedBox(width: 28.sp),
              Text(message('generic_selected_language'),
                  style:
                      TextStyle(color: context.theme.colorScheme.primary, fontSize: 16.sp))
            ],
          ),
          SizedBox(height: 10.sp),
          languages(context, action),
          Row(
            children: [
              SizedBox(width: 28.sp),
              Flexible(
                  child: Text(message('message_language_settings_info'),
                      style: TextStyle(
                          color: context.theme.colorScheme.secondary, fontSize: 12.sp))),
              SizedBox(width: 28.sp),
            ],
          ),
        ],
      ),
    ));
  }

  Widget languages(BuildContext context, LanguageSettingViewModel action) {
    final gapBetweenBadge = 11.sp;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Column(
          children: [
            languageBox(
              context,
                '한국어', 'Korean', isKorea, () => action.onLanguageTap(true)),
            SizedBox(height: gapBetweenBadge),
            languageBox(
              context,
                '영어', 'English', !isKorea, () => action.onLanguageTap(false)),
            SizedBox(height: gapBetweenBadge),
          ],
        ));
  }

  Widget languageBox(
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
                          color: context.theme.colorScheme.primary, fontSize: 16.sp)),
                  Text(subtitle,
                      style: TextStyle(
                          color: context.theme.colorScheme.secondary, fontSize: 14.sp))
                ]),
                Icon(Icons.check,
                    size: 20.sp,
                    color: isSelected
                        ?  context.theme.colorScheme.primary
                        :  context.theme.colorScheme.outlineVariant),
              ],
            ),
          ),
        ));
  }
}
