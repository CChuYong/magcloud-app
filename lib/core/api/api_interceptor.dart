import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:magcloud_app/core/api/dto/common/generic_error.dart';
import 'package:magcloud_app/core/util/device_info_util.dart';
import 'package:magcloud_app/core/util/snack_bar_util.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../di.dart';
import '../../global_routes.dart';
import '../service/auth_service.dart';
import '../util/i18n.dart';

class ApiInterceptor extends Interceptor {
  final AuthService authService = inject<AuthService>();
  final Dio dio = inject<Dio>();
  final PackageInfo packageInfo = inject<PackageInfo>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('[REQ] [${options.method}] ${options.uri}');

    if (authService.isAuthenticated()) {
      options.headers["X-AUTH-TOKEN"] = authService.getAccessToken();
    }
    options.headers["X-APP-VERSION"] = packageInfo.version;
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
          await authService.logout();
          await GlobalRoute.fadeRoute('/login');
        }
      }
    } else if(statusCode == 403) {
      log("403!!!!");
    } else if(statusCode == 404) {
      //Ignore
    } else {
      log(err.response?.data?.toString() ?? 'unknown dio error');
      if (err.response != null) {
        final errorBody = GenericError.fromJson(err.response!.data);
        SnackBarUtil.errorSnackBar(
            message: errorBody.message
        );
      }
    }
    return handler.next(err);
  }
}
