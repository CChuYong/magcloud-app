
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/view/component/base_settings_layout.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../core/framework/base_view.dart';
import '../../../core/util/i18n.dart';
import '../../../view_model/setting_view/notification_config_view_model.dart';
import '../../component/touchableopacity.dart';
import '../../designsystem/base_color.dart';

class NotificationConfigView extends BaseView<
    NotificationConfigView,
    NotificationConfigViewModel,
    NotificationConfigViewState> {

  NotificationConfigView({super.key});


  PreferredSizeWidget buildAppBar() {
    return AppBar(
      backgroundColor: BaseColor.defaultBackgroundColor,
      elevation: 0,
      title: Text(
        '알림 설정 변경하기',
        style: TextStyle(
          color: BaseColor.warmGray500,
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Widget render(BuildContext context, NotificationConfigViewModel action,
      NotificationConfigViewState state) {
    return BaseSettingLayout(
title: message('menu_notification'),
          child: Padding(
              padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 10.sp),
              child: Column(
                children: [
                  ToggleableMenuElement(
                      '친구 관련 알림',
                      '친구 추가, 요청 등의 알림을 보내드려요!',
                      Icons.people,
                      (e) => action.changeSetting('socialAlert', e == 0),
                      state.socialAlert),
                  ToggleableMenuElement(
                      '앱 관련 알림',
                      '앱의 공지사항, 업데이트 등을 알려드려요!',
                      Icons.phone_android,
                      (e) => action.changeSetting('noticeAlert', e == 0),
                      state.noticeAlert)
                ],
              ),
            ),

    );
  }

  @override
  NotificationConfigViewModel initViewModel() => NotificationConfigViewModel();
}

typedef CancelToggle = Future<bool> Function(int? index);

class ToggleableMenuElement extends StatelessWidget {
  String text;
  String description;
  IconData icon;

  //Function onTap;
  bool initialState;
  CancelToggle onTap;

  ToggleableMenuElement(
      this.text, this.description, this.icon, this.onTap, this.initialState,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 0.sp, top: 13.sp, bottom: 13.sp, right: 0.sp),
            child: Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(icon, size: 19.sp, color: BaseColor.warmGray500),
                    SizedBox(width: 12.sp),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          style: TextStyle(
                            color: BaseColor.warmGray500,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          description,
                          style: TextStyle(
                            color: BaseColor.warmGray500,
                            fontSize: 10.sp,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                ToggleSwitch(
                  initialLabelIndex: initialState ? 0 : 1,
                  totalSwitches: 2,
                  labels: ['켜짐', '꺼짐'],
                  cancelToggle: onTap,
                  activeFgColor: BaseColor.warmGray200,
                  activeBgColor: [BaseColor.warmGray600],
                  inactiveFgColor: BaseColor.warmGray500,
                  inactiveBgColor: BaseColor.warmGray300,
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
