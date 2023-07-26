import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:get/get.dart' as getx;
import 'package:launch_review/launch_review.dart';
import 'package:magcloud_app/core/api/dto/common/generic_error.dart';
import 'package:magcloud_app/core/framework/state_store.dart';
import 'package:magcloud_app/core/util/device_info_util.dart';
import 'package:magcloud_app/core/util/snack_bar_util.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../di.dart';
import '../../global_routes.dart';
import '../../main.dart';
import '../service/auth_service.dart';
import '../util/i18n.dart';

class ApiInterceptor extends Interceptor {
  final AuthService authService;
  final Dio dio;
  final PackageInfo packageInfo;

  ApiInterceptor({required this.authService, required this.dio, required this.packageInfo});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print(
        '[REQ] [${options.method}] ${options.uri} ${authService.getAccessToken()}');

    if (authService.isAuthenticated()) {
      options.headers["X-AUTH-TOKEN"] = authService.getAccessToken();
    }
    options.headers["X-APP-VERSION"] = packageInfo.version;
    options.headers["X-APP-KEY"] = magCloudAppKey;
    options.headers["X-APP-LANGUAGE"] = isKorea ? 'KOR' : 'ENG';
    options.headers["X-OS-VERSION"] = DeviceInfoUtil.getOsAndVersion();
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode ?? 500;
    print("$statusCode ${err.requestOptions.path}");
    if(err.requestOptions.path == "/v1/auth/refresh") {
      await authService.logout(false);
      GlobalRoute.clearAllAndFadeRoute('/login');
      return handler.next(err);
    }
    if (statusCode == 401) {
      if (authService.isAuthenticated()) {
        // try refresh it
        final refreshResult = await authService.refreshWithToken();
        if (refreshResult == AuthResult.SUCCEED) {
          // Re-Request when refresh succeed
          var response = await dio.request(
            err.requestOptions.path,
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
            ),
          );
          return handler.resolve(response);
        } else {
          await authService.logout(false);
          GlobalRoute.clearAllAndFadeRoute('/login');
        }
      }
    } else if (statusCode == 403) {
      log("403!!!!");
      try {
        final errorBody = GenericError.fromJson(err.response!.data);
        if (errorBody.code == "CM0010") {
          StateStore.setString("updateBaseline", inject<PackageInfo>().version);
          await showPlatformDialog(
            context: getx.Get.context!,
            builder: (context) => BasicDialogAlert(
              title: Text("MagCloud"),
              content:
              Text(message('message_update_needed')),
              actions: <Widget>[
                BasicDialogAction(
                  title: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
          //await NativeDialog.alert(message('message_update_needed'));
          await LaunchReview.launch(writeReview: false);
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      } catch (e) {}
    } else if (statusCode == 404) {
      //Ignore
    } else {
      log(err.response?.data?.toString() ?? 'unknown dio error');
      if (err.response != null) {
        final errorBody = GenericError.fromJson(err.response!.data);
        SnackBarUtil.errorSnackBar(message: errorBody.message);
      }
    }
    return handler.next(err);
  }
}
