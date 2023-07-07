import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        child:
      BaseSettingLayout(
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
                  TextStyle(color: BaseColor.warmGray600, fontSize: 16.sp))
            ],
          ),
          SizedBox(height: 10.sp),
          languages(action),
          Row(
            children: [
              SizedBox(width: 28.sp),
              Flexible(child: Text(message('message_language_settings_info'),
                  style:
                  TextStyle(color: BaseColor.warmGray500, fontSize: 12.sp))),
              SizedBox(width: 28.sp),
            ],
          ),
        ],
      ),
    ));
  }

  Widget languages(LanguageSettingViewModel action) {
    final gapBetweenBadge = 11.sp;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Column(
          children: [
            languageBox('한국어', 'Korean', isKorea, () => action.onLanguageTap(true)),
            SizedBox(height: gapBetweenBadge),
            languageBox('영어', 'English', !isKorea, () => action.onLanguageTap(false)),
            SizedBox(height: gapBetweenBadge),
          ],
        ));
  }

  Widget languageBox(String title, String subtitle, bool isSelected, void Function() onTap) {
    return TouchableOpacity(
      onTap: onTap,
        child: Container(
      decoration: BoxDecoration(
          color: BaseColor.warmGray50, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 20.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style:
                      TextStyle(color: BaseColor.warmGray600, fontSize: 16.sp)),
              Text(subtitle,
                  style:
                      TextStyle(color: BaseColor.warmGray500, fontSize: 14.sp))
            ]),
            Icon(Icons.check,
                size: 20.sp,
                color:
                    isSelected ? BaseColor.warmGray700 : BaseColor.warmGray300),
          ],
        ),
      ),
    ));
  }
}
