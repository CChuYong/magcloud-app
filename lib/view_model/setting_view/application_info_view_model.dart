import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/core/repository/diary_repository.dart';
import 'package:magcloud_app/core/service/diary_service.dart';
import 'package:magcloud_app/core/util/font.dart';
import 'package:magcloud_app/core/util/snack_bar_util.dart';
import 'package:magcloud_app/global_routes.dart';
import 'package:magcloud_app/view/page/settings_view/application_info_view.dart';
import 'package:magcloud_app/view_model/calendar_view/calendar_base_view_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/util/i18n.dart';
import '../../di.dart';
import '../../view/dialog/confirm_dialog.dart';

class ApplicationInfoViewState {
  final PackageInfo packageInfo;

  ApplicationInfoViewState(this.packageInfo);
}

class ApplicationInfoViewModel extends BaseViewModel<ApplicationInfoView,
    ApplicationInfoViewModel, ApplicationInfoViewState> {
  ApplicationInfoViewModel()
      : super(ApplicationInfoViewState(inject<PackageInfo>()));

  @override
  Future<void> initState() async {}

  @override
  Future<bool> onWillPop() {
    return super.onWillPop();
  }

  void resetCacheData() async {
    final result = await confirmDialog(
        message('generic_reset_cache'), message('message_cache_reset_subtitle'),
        confirmText: message('generic_reset'));
    if (result != true) return;
    await asyncLoading(() async {
      await inject<DiaryRepository>().truncateTable();
      inject<DiaryService>().syncedSet.clear();
      SnackBarUtil.infoSnackBar(message: message('message_reset_completed'));
    });
  }

  void resetSettings() async {
    final result = await confirmDialog(message('generic_reset_settings'),
        message('message_settings_reset_subtitle'),
        confirmText: message('generic_reset'));
    if (result != true) return;

    setDiaryFontSize(defaultFontSize);
    setDiaryFont('KyoboHandWriting2019');
    SnackBarUtil.infoSnackBar(message: message('message_reset_completed'));
  }

  void watchOpenSourceLicense() async {
    await GlobalRoute.ossView();
  }
}
