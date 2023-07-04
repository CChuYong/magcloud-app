import 'package:flutter/src/widgets/framework.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/view_model/login_view/login_view_model.dart';

import '../../view_model/login_view/login_view_state.dart';

class LoginView extends BaseView<LoginView, LoginViewModel, LoginViewState> {
  @override
  LoginViewModel initViewModel() => LoginViewModel();

  @override
  Widget render(BuildContext context, LoginViewModel action, LoginViewState state) {
    // TODO: implement render
    throw UnimplementedError();
  }

}
