import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:magcloud_app/core/service/auth_service.dart';
import 'package:magcloud_app/global_routes.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';
import 'package:magcloud_app/view/navigator_view.dart';
import 'package:magcloud_app/view/page/login_view.dart';

import 'core/framework/state_store.dart';
import 'di.dart';
import 'firebase_options.dart';

const magCloudAppKey = "b93b5462-264c-44c4-a3ec-c8fe5bf0a8e7";
const apiBaseUrl =
    "https://magcloud.chuyong.kr/api"; //http://100.116.87.112:9999/api
void main() async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('ko_KR', null);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
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
