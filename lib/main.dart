import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
const apiBaseUrl = "http://100.116.87.112:9999/api";
   // "https://magcloud.chuyong.kr/api"; //http://100.116.87.112:9999/api
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
          theme: _lightTheme,
          darkTheme: _darkTheme,
          themeMode: StateStore.getThemeMode(),
          home: inject<AuthService>().isAuthenticated()
              ? NavigatorView()
              : LoginView(),
          navigatorObservers: [GlobalRoute.observer],
        )));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

ThemeData _lightTheme = ThemeData(
  fontFamily: 'Pretendard',
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: BaseColor.defaultBackgroundColor,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: BaseColor.defaultBackgroundColor,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  colorScheme: const ColorScheme(
    onPrimary: BaseColor.blue300, //required
    onSecondary: BaseColor.blue300, //required
    primary: BaseColor.warmGray700, // point color1
    primaryContainer: BaseColor.blue300, // point color2
    secondary:BaseColor.warmGray500, // point color3
    background: BaseColor.defaultBackgroundColor, // app backgound
    surface: BaseColor.defaultSplashBackgroundColor, // card background
    outline: BaseColor.warmGray200, // card l
    outlineVariant: BaseColor.warmGray300, /// ine or divider
    surfaceVariant: BaseColor.blue300, // disabled
    onSurface: BaseColor.blue300, // text3
    onSurfaceVariant: BaseColor.blue300, //text2
    onBackground: BaseColor.warmGray100, //text1
    error: BaseColor.blue300,  // danger
    tertiary: BaseColor.blue300, // normal
    tertiaryContainer: BaseColor.blue300, // safe
    inversePrimary: BaseColor.warmGray200,


    onError: BaseColor.blue300, //no use
    brightness: Brightness.light,

  ),
);

ThemeData _darkTheme = ThemeData(
  fontFamily: 'Pretendard',
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: DarkBaseColor.defaultBackgroundColor,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: DarkBaseColor.defaultBackgroundColor,
      statusBarIconBrightness: Brightness.light,
    ),
  ),
  colorScheme: const ColorScheme(
    onPrimary: BaseColor.blue300, //required
    onSecondary: BaseColor.blue300, //required
    primary: BaseColor.warmGray50, // point color1
    primaryContainer: BaseColor.blue300, // point color2
    secondary:BaseColor.warmGray200, // point color3
    background: DarkBaseColor.defaultBackgroundColor, // app backgound
    surface: DarkBaseColor.defaultSplashBackgroundColor, // card background
    outline: BaseColor.warmGray700, // card line or divider
    outlineVariant: BaseColor.warmGray700,
    surfaceVariant: BaseColor.blue300, // disabled
    onSurface: BaseColor.blue300, // text3
    onSurfaceVariant: BaseColor.blue300, //text2
    onBackground: BaseColor.warmGray800, //text1
    error: BaseColor.blue300,  // danger
    tertiary: BaseColor.blue300, // normal
    tertiaryContainer: BaseColor.blue300, // safe
    inversePrimary: BaseColor.warmGray700,


    onError: BaseColor.blue300, //no use
    brightness: Brightness.dark,

  ),
);
