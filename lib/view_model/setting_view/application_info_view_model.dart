import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/global_routes.dart';
import 'package:magcloud_app/view/page/settings_view/application_info_view.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/util/i18n.dart';
import '../../view/dialog/confirm_dialog.dart';

class ApplicationInfoViewState {
  PackageInfo? packageInfo;
}

class ApplicationInfoViewModel extends BaseViewModel<ApplicationInfoView,
    ApplicationInfoViewModel, ApplicationInfoViewState> {
  ApplicationInfoViewModel() : super(ApplicationInfoViewState());

  @override
  Future<void> initState() async {
    state.packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  Future<bool> onWillPop() {
    return super.onWillPop();
  }

  void resetCacheData() async {
    final result = await confirmDialog(
        message('generic_reset_cache'), message('message_cache_reset_subtitle'),
        confirmText: message('generic_reset'));
    if (result != true) return;
  }

  void resetSettings() async {
    final result = await confirmDialog(message('generic_reset_settings'),
        message('message_settings_reset_subtitle'),
        confirmText: message('generic_reset'));
    if (result != true) return;
  }

  void watchOpenSourceLicense() async {
    await GlobalRoute.ossView();
  }
}
