import 'package:magcloud_app/core/api/dto/notification_request.dart';
import 'package:magcloud_app/core/api/open_api.dart';
import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/di.dart';

import '../../view/page/settings_view/notification_config_view.dart';

class NotificationConfigViewState {
  bool socialAlert;
  bool noticeAlert;
  bool feedAlert;

  NotificationConfigViewState(this.socialAlert, this.noticeAlert, this.feedAlert);
}

class NotificationConfigViewModel extends BaseViewModel<NotificationConfigView,
    NotificationConfigViewModel, NotificationConfigViewState> {
  NotificationConfigViewModel()
      : super(NotificationConfigViewState(
          true,
          true,
    true,
        ));

  final OpenAPI openAPI = inject<OpenAPI>();

  @override
  Future<void> initState() async {
    final result = await openAPI.getNotificationConfig();
    state.socialAlert = result.social;
    state.noticeAlert = result.app;
    state.feedAlert = result.feed;
  }

  Future<bool> changeSetting(String type, bool enabled) async {
    // await openAPI.updateNotification(UpdateNotificationRequest(type, enabled));
    await asyncLoading(() async {
      switch (type) {
        case 'social':
          state.socialAlert = enabled;
          break;
        case 'notice':
          state.noticeAlert = enabled;
          break;
        case 'feed':
          state.feedAlert = enabled;
          break;
      }

      final result = await openAPI.updateNotificationConfig(NotificationRequest(app: state.noticeAlert, social: state.socialAlert, feed: state.feedAlert));

      setState(() {
        state.socialAlert = result.social;
        state.noticeAlert = result.app;
        state.feedAlert = result.feed;
      });
    });
    return false;
  }
}
