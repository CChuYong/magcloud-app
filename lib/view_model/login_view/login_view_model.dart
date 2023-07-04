import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/view/page/login_view.dart';
import 'package:magcloud_app/view_model/login_view/login_view_state.dart';

class LoginViewModel extends BaseViewModel<LoginView, LoginViewModel, LoginViewState> {
  LoginViewModel() : super(LoginViewState());

  @override
  Future<void> initState() async {

  }
}
