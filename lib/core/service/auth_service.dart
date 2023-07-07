import 'package:google_sign_in/google_sign_in.dart';
import 'package:magcloud_app/core/framework/state_store.dart';
import 'package:magcloud_app/core/model/auth_token.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/core/util/snack_bar_util.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  AuthToken? token;

  AuthService() {
    final accessToken = StateStore.getString('accessToken');
    final refreshToken = StateStore.getString('refreshToken');
    if (accessToken != null && refreshToken != null) {
      authenticate(
          AuthToken(accessToken: accessToken, refreshToken: refreshToken));
    }
  }

  bool isAuthenticated() => token != null;

  String? getAccessToken() => token?.accessToken;

  Future<AuthorizationCredentialAppleID> _signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    return appleCredential;
  }

  Future<GoogleSignInAuthentication?> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    return await googleUser?.authentication;
  }

  Future<AuthResult> signInWithApple() async {
    try {
      final authResult = await _signInWithApple();
      // final authenticateResult = await openApi.authenticate(AuthRequest(
      //     provider: 'APPLE', token: authResult.identityToken ?? ""));
      // await authService.authenticate(AuthToken(
      //   authenticateResult.accessToken,
      //   authenticateResult.refreshToken,
      // ));
      return AuthResult.SUCCEED;
    } catch (e) {
      SnackBarUtil.errorSnackBar(message: message('message_login_failed'));
      return AuthResult.FAILED;
    }
  }

  Future<AuthResult> signInWithGoogle() async {
    try {
      final authResult = await _signInWithGoogle();
      // final authenticateResult = await openApi.authenticate(AuthRequest(
      //     provider: 'APPLE', token: authResult.identityToken ?? ""));
      // await authService.authenticate(AuthToken(
      //   authenticateResult.accessToken,
      //   authenticateResult.refreshToken,
      // ));
      return AuthResult.SUCCEED;
    } catch (e) {
      SnackBarUtil.errorSnackBar(message: message('message_login_failed'));
      return AuthResult.FAILED;
    }
  }

  Future<AuthResult> refreshWithToken() async {
    try {
      final authResult = await _signInWithGoogle();
      // final authenticateResult = await openApi.authenticate(AuthRequest(
      //     provider: 'APPLE', token: authResult.identityToken ?? ""));
      // await authService.authenticate(AuthToken(
      //   authenticateResult.accessToken,
      //   authenticateResult.refreshToken,
      // ));
      return AuthResult.SUCCEED;
    } catch (e) {
      SnackBarUtil.errorSnackBar(message: message('message_login_failed'));
      return AuthResult.FAILED;
    }
  }

  Future<void> authenticate(AuthToken token) async {
    this.token = token;
    StateStore.setString('accessToken', token.accessToken);
    StateStore.setString('refreshToken', token.refreshToken);
  }

  Future<void> logout() async {
    token = null;
    StateStore.clear('accessToken');
    StateStore.clear('refreshToken');
  }
}

enum AuthResult {
  SUCCEED,
  FAILED;
}
