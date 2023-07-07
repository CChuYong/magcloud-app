import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/core/util/font.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';

import '../../../view_model/setting_view/application_info_view_model.dart';
import '../../component/base_settings_layout.dart';
import '../../designsystem/base_color.dart';

class ApplicationInfoView extends BaseView<ApplicationInfoView, ApplicationInfoViewModel,
    ApplicationInfoViewState> {
  ApplicationInfoView({super.key});

  @override
  ApplicationInfoViewModel initViewModel() => ApplicationInfoViewModel();

  @override
  Widget render(BuildContext context, ApplicationInfoViewModel action,
      ApplicationInfoViewState state) {
    final gapBetweenElements = 10.sp;
    return  BaseSettingLayout(
      key: Key(isKorea.toString()),
      title: message('menu_app_info'),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.sp),
          child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15.sp),
          row(message('generic_app_name'),  Text(state.packageInfo?.appName ?? '',
              style:
              TextStyle(color: BaseColor.warmGray400, fontSize: 14.sp)
          )),
          SizedBox(height: gapBetweenElements),
          row(message('generic_app_version'),  Text(state.packageInfo?.version ?? '',
              style:
              TextStyle(color: BaseColor.warmGray400, fontSize: 14.sp)
          )),
          SizedBox(height: gapBetweenElements),
          row(message('generic_app_build_no'),  Text(state.packageInfo?.buildNumber ?? '',
              style:
              TextStyle(color: BaseColor.warmGray400, fontSize: 14.sp)
          )),
          SizedBox(height: 20.sp),
          Divider(color: BaseColor.warmGray200, height: 1),
          SizedBox(height: 20.sp),
          row('캐시 데이터 초기화', button('초기화', (){})),
          SizedBox(height: gapBetweenElements),
          row('오픈소스 라이선스', button('보기', (){})),
        ],
      )),
    );
  }

  Widget row(String title, Widget side) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style:
            TextStyle(color: BaseColor.warmGray600, fontSize: 14.sp)
        ),
        side
      ],
    );
  }

  Widget button(String title, void Function() onTap) {
    return TouchableOpacity(
      onTap: onTap,
        child:
      Container(
      decoration: BoxDecoration(
        color: BaseColor.warmGray200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
        child:Text(title,
          style:
          TextStyle(color: BaseColor.warmGray600, fontSize: 12.sp)
      ),
    )));
  }
}
