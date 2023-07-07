import 'package:magcloud_app/core/framework/base_action.dart';

import '../../view/page/settings_view/notification_config_view.dart';

class NotificationConfigViewState {
  bool socialAlert;
  bool badSoundAlert;
  bool nonBadSoundAlert;
  bool noticeAlert;

  NotificationConfigViewState(this.socialAlert, this.badSoundAlert,
      this.nonBadSoundAlert, this.noticeAlert);
}

class NotificationConfigViewModel extends BaseViewModel<
    NotificationConfigView,
    NotificationConfigViewModel,
    NotificationConfigViewState> {
  NotificationConfigViewModel()
      : super(NotificationConfigViewState(
          true,
          true,
          true,
          true,
        ));

  @override
  Future<void> initState() async => {};

  Future<bool> changeSetting(String type, bool enabled) async {
   // await openAPI.updateNotification(UpdateNotificationRequest(type, enabled));
    return false;
  }
}
