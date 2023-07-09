import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/core/service/auth_service.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/global_routes.dart';
import 'package:magcloud_app/view/page/login_view.dart';
import 'package:magcloud_app/view_model/login_view/login_view_state.dart';

class LoginViewModel
    extends BaseViewModel<LoginView, LoginViewModel, LoginViewState> {
  LoginViewModel() : super(LoginViewState());

  final AuthService authService = inject<AuthService>();

  @override
  Future<void> initState() async {}

  Future<void> onAppleLogin() async {
    AuthResult loginResult = AuthResult.FAILED;
    try{
      setLoading(true);
      loginResult = await authService.signInWithApple();
    } finally{
      setLoading(false);
    }
    if(loginResult == AuthResult.SUCCEED){
      GlobalRoute.goMain();
    }
  }

  Future<void> onGoogleLogin() async {
    AuthResult loginResult = AuthResult.FAILED;
    try{
      setLoading(true);
      loginResult = await authService.signInWithGoogle();
    } finally{
      setLoading(false);
    }
    if(loginResult == AuthResult.SUCCEED){
      GlobalRoute.goMain();
    }
  }

  void toggleLanguage() {
    setState(() {
      toggleEng();
    });
  }
}
