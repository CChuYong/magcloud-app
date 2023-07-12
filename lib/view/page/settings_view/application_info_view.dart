import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/core/service/online_service.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';

import '../../../view_model/setting_view/application_info_view_model.dart';
import '../../component/base_settings_layout.dart';
import '../../designsystem/base_color.dart';

class ApplicationInfoView extends BaseView<ApplicationInfoView,
    ApplicationInfoViewModel, ApplicationInfoViewState> {
  ApplicationInfoView({super.key});

  @override
  ApplicationInfoViewModel initViewModel() => ApplicationInfoViewModel();

  @override
  Widget render(BuildContext context, ApplicationInfoViewModel action,
      ApplicationInfoViewState state) {
    final gapBetweenElements = 10.sp;
    return BaseSettingLayout(
      key: Key(isKorea.toString()),
      title: message('menu_app_info'),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.sp),
              row(
                  message('generic_app_name'),
                  Text(state.packageInfo?.appName ?? '',
                      style: TextStyle(
                          color: BaseColor.warmGray400, fontSize: 14.sp))),
              SizedBox(height: gapBetweenElements),
              row(
                  message('generic_app_version'),
                  Text(state.packageInfo?.version ?? '',
                      style: TextStyle(
                          color: BaseColor.warmGray400, fontSize: 14.sp))),
              SizedBox(height: gapBetweenElements),
              row(
                  message('generic_app_build_no'),
                  Text(state.packageInfo?.buildNumber ?? '',
                      style: TextStyle(
                          color: BaseColor.warmGray400, fontSize: 14.sp))),
              SizedBox(height: gapBetweenElements),
              row(
                  message('generic_offline_mode'),
                  Text(
                      inject<OnlineService>().isOnlineMode()
                          ? message('generic_disactivated')
                          : message('generic_activated'),
                      style: TextStyle(
                          color: BaseColor.warmGray400, fontSize: 14.sp))),
              SizedBox(height: 20.sp),
              const Divider(color: BaseColor.warmGray200, height: 1),
              SizedBox(height: 20.sp),
              row(message('generic_reset_cache'),
                  button(message('generic_reset'), action.resetCacheData)),
              SizedBox(height: gapBetweenElements),
              row(message('generic_reset_settings'),
                  button(message('generic_reset'), action.resetSettings)),
              SizedBox(height: gapBetweenElements),
              row(
                  message('generic_open_source_license'),
                  button(
                      message('generic_watch'), action.watchOpenSourceLicense)),
            ],
          )),
    );
  }

  Widget row(String title, Widget side) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(color: BaseColor.warmGray600, fontSize: 14.sp)),
        side
      ],
    );
  }

  Widget button(String title, void Function() onTap) {
    return TouchableOpacity(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
              color: BaseColor.warmGray200,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
              child: Text(title,
                  style:
                      TextStyle(color: BaseColor.warmGray500, fontSize: 12.sp)),
            )));
  }
}
