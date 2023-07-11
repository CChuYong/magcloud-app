import 'package:google_sign_in/google_sign_in.dart';
import 'package:magcloud_app/core/api/dto/auth_refresh_request.dart';
import 'package:magcloud_app/core/api/dto/auth_request.dart';
import 'package:magcloud_app/core/api/dto/device_request.dart';
import 'package:magcloud_app/core/framework/state_store.dart';
import 'package:magcloud_app/core/model/auth_token.dart';
import 'package:magcloud_app/core/repository/diary_repository.dart';
import 'package:magcloud_app/core/service/diary_service.dart';
import 'package:magcloud_app/core/service/notification_service.dart';
import 'package:magcloud_app/core/util/device_info_util.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/core/util/snack_bar_util.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../di.dart';
import '../api/open_api.dart';
import '../model/user.dart';

class AuthService {
  AuthToken? token;
  final OpenAPI openApi;
  User? initialUser;
  bool isNewUser = false;

  AuthService(this.openApi);

  bool isAuthenticated() => token != null;

  String? getAccessToken() => token?.accessToken;

  Future<void> initialize() async {
    final accessToken = StateStore.getString('accessToken');
    final refreshToken = StateStore.getString('refreshToken');
    if (accessToken != null && refreshToken != null) {
      try{
        authenticate(
            AuthToken(accessToken: accessToken, refreshToken: refreshToken));
        initialUser = (await openApi.getMyProfile()).toDomain();
        final previousUser = StateStore.getString("lastUserId");
        if(initialUser != null && previousUser != null && previousUser != initialUser!.userId) {
          await flushStorage();
        }
      }catch(e) {
        //Maybe offline?
      }
    }
  }

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
      if(authResult.identityToken == null) return AuthResult.FAILED;
      final authenticateResult = await openApi.authenticate(
          AuthRequest(
            provider: 'APPLE', token: authResult.identityToken ?? ""
          ));
      isNewUser = authenticateResult.isNewUser;
      await authenticate(AuthToken(
        accessToken: authenticateResult.accessToken,
        refreshToken: authenticateResult.refreshToken,
      ));
      return AuthResult.SUCCEED;
    } catch (e) {
      if(e is SignInWithAppleAuthorizationException) {
        if(e.code == AuthorizationErrorCode.canceled) {
          return AuthResult.FAILED;
        }
      }
      SnackBarUtil.errorSnackBar(message: message('message_login_failed'));
      return AuthResult.FAILED;
    }
  }

  Future<AuthResult> signInWithGoogle() async {
    try {
      final authResult = await _signInWithGoogle();
      if(authResult == null || authResult.accessToken == null) return AuthResult.FAILED;
      final authenticateResult = await openApi.authenticate(
          AuthRequest(
              provider: 'GOOGLE', token: authResult.accessToken ?? ""
          ));
      isNewUser = authenticateResult.isNewUser;
      await authenticate(AuthToken(
        accessToken: authenticateResult.accessToken,
        refreshToken: authenticateResult.refreshToken,
      ));
      return AuthResult.SUCCEED;
    } catch (e) {
      SnackBarUtil.errorSnackBar(message: message('message_login_failed'));
      return AuthResult.FAILED;
    }
  }

  Future<AuthResult> refreshWithToken() async {
    if(token == null) return AuthResult.FAILED;
    try {
      final authenticateResult = await openApi.refresh(AuthRefreshRequest(
          refreshToken: token!.refreshToken,
      ));
      await authenticate(AuthToken(
        accessToken: authenticateResult.accessToken,
        refreshToken: authenticateResult.refreshToken,
      ));
      return AuthResult.SUCCEED;
    } catch (e) {
      SnackBarUtil.errorSnackBar(message: message('message_login_failed'));
      return AuthResult.FAILED;
    }
  }

  Future<void> authenticate(AuthToken token) async {
    print("Logged in!!");
    this.token = token;
    StateStore.setString('accessToken', token.accessToken);
    StateStore.setString('refreshToken', token.refreshToken);
    final notificationService = inject<NotificationService>();
    await openApi.registerDevice(
        DeviceRequest(
            deviceToken: notificationService.token!,
            deviceInfo: DeviceInfoUtil.getOsAndVersion()));

  }

  Future<void> logout(bool intend) async {
    print("Logged Out!!");
    final notificationService = inject<NotificationService>();
    try{
      await openApi.unRegisterDevice(
          DeviceRequest(
              deviceToken: notificationService.token!,
              deviceInfo: DeviceInfoUtil.getOsAndVersion()));
    }catch(e) {}

    token = null;
    StateStore.clear('accessToken');
    StateStore.clear('refreshToken');
    if(initialUser != null) {
      StateStore.setString('lastUserId', initialUser!.userId);
    }
    if(intend) {
      await flushStorage();
    }
  }

  Future<void> flushStorage() async {
    StateStore.clearAll();
    await inject<DiaryRepository>().truncateTable();
    inject<DiaryService>().syncedSet.clear();
  }
}

enum AuthResult {
  SUCCEED,
  FAILED;
}
