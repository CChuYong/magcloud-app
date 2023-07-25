import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:magcloud_app/oss_licenses.dart';

import '../../../core/util/i18n.dart';
import '../../component/base_settings_layout.dart';

class OpenSourceLicenseView extends StatelessWidget {
  const OpenSourceLicenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSettingLayout(
      title: message('generic_open_source_license'),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.sp),
          child: Column(children: [
            Expanded(
              child: CustomScrollView(reverse: false, slivers: [
                SliverList(
                    delegate: SliverChildListDelegate(
                        ossLicenses.map((e) => element(context, e)).toList())),
              ]),
            )
          ])),
    );
  }

  Widget element(BuildContext context, Package package) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${package.name} (${package.version})",
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 18.sp,
            color: context.theme.colorScheme.primary,
          ),
        ),
        Text(
          package.license ?? '',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12.sp,
            color: context.theme.colorScheme.secondary,
          ),
        ),
        SizedBox(height: 24.sp),
      ],
    );
  }
}
