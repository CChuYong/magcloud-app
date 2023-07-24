import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:magcloud_app/core/service/auth_service.dart';
import 'package:magcloud_app/global_routes.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';
import 'package:magcloud_app/view/navigator_view.dart';
import 'package:magcloud_app/view/page/login_view.dart';

import 'core/framework/state_store.dart';
import 'di.dart';
import 'firebase_options.dart';

const magCloudAppKey = "8ec820bf-9081-400c-ac6d-61dcb37fd1ea";
const apiBaseUrl =
    "https://magcloud.chuyong.kr/api"; //http://100.116.87.112:9999/api
void main() async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('ko_KR', null);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    KakaoSdk.init(nativeAppKey: '4dd02056d64991edbf652f5be8b3d378');
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    await StateStore.init();
    await initializeDependencies();

    runApp(ScreenUtilInit(
        builder: (context, widget) => GetMaterialApp(
          // home: const MyApp(),
          theme: ThemeData(
            fontFamily: 'Pretendard',
            colorScheme: ColorScheme.fromSeed(
                seedColor: BaseColor.defaultBackgroundColor),
            useMaterial3: true,
          ),
          home: inject<AuthService>().isAuthenticated()
              ? NavigatorView()
              : LoginView(),
          navigatorObservers: [GlobalRoute.observer],
        )));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}
