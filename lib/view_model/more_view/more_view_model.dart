import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/core/service/auth_service.dart';
import 'package:magcloud_app/core/service/user_service.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/global_routes.dart';
import 'package:magcloud_app/view_model/more_view/more_view_state.dart';

import '../../view/page/more_view.dart';

class MoreViewModel
    extends BaseViewModel<MoreView, MoreViewModel, MoreViewState> {
  MoreViewModel() : super(MoreViewState());

  @override
  Future<void> initState() async {
    state.me = await inject<UserService>().getMe();
  }

  Future<void> onTapMyProfiles() async {

  }

  Future<void> onTapNotification() async {

  }

  Future<void> onTapFonts() async {

  }

  Future<void> onTapLanguage() async {

  }

  Future<void> onTapNotice() async {

  }

  Future<void> onTapPrivacy() async {

  }

  Future<void> onTapAppInfo() async {

  }

  Future<void> logout() async {
    await inject<AuthService>().logout();
    await GlobalRoute.fadeRoute('/login');
  }
}
