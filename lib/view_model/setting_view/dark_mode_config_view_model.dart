import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:magcloud_app/core/api/dto/notification_request.dart';
import 'package:magcloud_app/core/api/open_api.dart';
import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/view/page/settings_view/dark_mode_config_view.dart';

import '../../core/framework/state_store.dart';
import '../../view/page/settings_view/notification_config_view.dart';

class DarkModeConfigViewState {

}

class DarkModeConfigViewModel extends BaseViewModel<DarkModeConfigView,
    DarkModeConfigViewModel, DarkModeConfigViewState> {
  DarkModeConfigViewModel()
      : super(DarkModeConfigViewState(

        ));

  @override
  Future<void> initState() async {

  }

  Future<void> changeSetting(ThemeMode mode) async {
    // await openAPI.updateNotification(UpdateNotificationRequest(type, enabled));
    await setStateAsync(() async {
      await StateStore.setThemeMode(mode);
      Get.changeThemeMode(mode);
    });

  }

  ThemeMode currentThemeMode() {
    return StateStore.getThemeMode();
  }
}
