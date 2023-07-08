import 'package:magcloud_app/core/framework/base_action.dart';

import '../../view/page/settings_view/notification_config_view.dart';

class NotificationConfigViewState {
  bool socialAlert;
  bool noticeAlert;

  NotificationConfigViewState(this.socialAlert, this.noticeAlert);
}

class NotificationConfigViewModel extends BaseViewModel<
    NotificationConfigView,
    NotificationConfigViewModel,
    NotificationConfigViewState> {
  NotificationConfigViewModel()
      : super(NotificationConfigViewState(
          true,
          true,
        ));

  @override
  Future<void> initState() async => {};

  Future<bool> changeSetting(String type, bool enabled) async {
   // await openAPI.updateNotification(UpdateNotificationRequest(type, enabled));
    setState(() {
      switch(type) {
        case 'social':
          state.socialAlert = enabled;
          break;
        case 'notice':
          state.noticeAlert = enabled;
          break;
      }
    });
    return false;
  }
}
