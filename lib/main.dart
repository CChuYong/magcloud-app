import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';
import 'package:magcloud_app/view/page/login_view.dart';

import 'core/framework/state_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StateStore.init();
  runApp(ScreenUtilInit(
      builder: (context, widget) =>
          GetMaterialApp(
            // home: const MyApp(),
            theme: ThemeData(
              fontFamily: 'Pretendard',
              colorScheme:
              ColorScheme.fromSeed(seedColor: BaseColor.defaultGreen),
              useMaterial3: true,
            ),
            initialRoute: '/',
            getPages: [
              GetPage(name: '/', page: () => LoginView()),
            ],
          )));
}
