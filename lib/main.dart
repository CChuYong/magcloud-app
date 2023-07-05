import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';
import 'package:magcloud_app/view/page/calendar_view/calendar_base_view.dart';
import 'package:magcloud_app/view/page/calendar_view/month_view.dart';
import 'package:magcloud_app/view/page/friend_view.dart';
import 'package:magcloud_app/view/page/login_view.dart';
import 'package:magcloud_app/view/page/more_view.dart';

import 'core/framework/state_store.dart';

import 'firebase_options.dart';
import 'main.config.dart';

final inject = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDependencies() => inject.init();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await StateStore.init();
  configureDependencies();
  runApp(ScreenUtilInit(
      builder: (context, widget) =>
          GetMaterialApp(
            // home: const MyApp(),
            theme: ThemeData(
              fontFamily: 'GmarketSans',
              colorScheme:
              ColorScheme.fromSeed(seedColor: BaseColor.defaultGreen),
              useMaterial3: true,
            ),
            initialRoute: '/calendar',
            getPages: [
              GetPage(name: '/', page: () => LoginView()),
              GetPage(name: '/calendar', page: () => const CalendarBaseView()),
              GetPage(name: '/more', page: () => const MoreView()),
              GetPage(name: '/friends', page: () => const FriendView()),
            ],
          )));
}
