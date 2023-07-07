import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/view/page/settings_view/application_info_view.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ApplicationInfoViewState {
  PackageInfo? packageInfo;
}

class ApplicationInfoViewModel extends BaseViewModel<ApplicationInfoView, ApplicationInfoViewModel, ApplicationInfoViewState> {
  ApplicationInfoViewModel() : super(ApplicationInfoViewState());

  @override
  Future<void> initState() async {
    state.packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  Future<bool> onWillPop() {
    print("I'm popping");
    return super.onWillPop();
  }

}
