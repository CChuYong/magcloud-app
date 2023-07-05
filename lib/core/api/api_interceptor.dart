import 'dart:developer';

import 'package:dio/dio.dart';

import '../../di.dart';
import '../service/auth_service.dart';

class ApiInterceptor extends Interceptor {
  final AuthService authService = inject<AuthService>();
  final Dio dio = inject<Dio>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('[REQ] [${options.method}] ${options.uri}');

    if (authService.isAuthenticated()) {
      options.headers["X-BCA-APP-TOKEN"] = authService.getAccessToken();
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    final isStatus401 = err.response?.statusCode == 401;
    if (isStatus401) {
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
        }
      }
    } else {
      log(err.response?.data?.toString() ?? 'unknown dio error');
      if (err.response != null) {
        print(err.response);
      }
    }
    return handler.next(err);
  }
}
