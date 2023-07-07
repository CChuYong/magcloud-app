import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:magcloud_app/core/api/api_interceptor.dart';
import 'package:magcloud_app/core/api/open_api.dart';
import 'package:magcloud_app/core/repository/diary_repository.dart';
import 'package:magcloud_app/core/service/auth_service.dart';
import 'package:magcloud_app/core/service/diary_service.dart';
import 'package:magcloud_app/core/service/online_service.dart';
import 'package:magcloud_app/core/service/user_service.dart';
import 'package:magcloud_app/global_routes.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';
import 'package:magcloud_app/view/page/calendar_view/calendar_base_view.dart';
import 'package:magcloud_app/view/page/login_view.dart';
import 'package:magcloud_app/view_model/navigator_view.dart';

import 'core/framework/state_store.dart';
import 'di.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await StateStore.init();
  final dio = Dio();
  inject.registerSingleton(dio);
  final client = OpenAPI(dio, baseUrl: 'https://magcloud.chuyong.kr/api/v1');

  inject.registerSingleton(client);
  final authService = AuthService();
  inject.registerSingleton(authService);

  dio.interceptors.add(ApiInterceptor());

  final diary = await DiaryRepository.create();
  inject.registerSingleton(diary);
  final onlineService = OnlineService();
  inject.registerSingleton(onlineService);
  inject.registerSingleton(DiaryService(onlineService, diary));
  inject.registerSingleton(UserService());

  runApp(ScreenUtilInit(
      builder: (context, widget) => GetMaterialApp(
            // home: const MyApp(),
            theme: ThemeData(
              fontFamily: 'GmarketSans',
              colorScheme: ColorScheme.fromSeed(
                  seedColor: BaseColor.defaultBackgroundColor),
              useMaterial3: true,
            ),
            home: authService.isAuthenticated() ? NavigatorView() : LoginView(),
        navigatorObservers: [GlobalRoute.observer],
          )));
}
