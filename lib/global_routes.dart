import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:magcloud_app/core/service/online_service.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/core/util/snack_bar_util.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/view/page/calendar_view/calendar_base_view.dart';
import 'package:magcloud_app/view/page/login_view.dart';
import 'package:magcloud_app/view/page/more_view.dart';
import 'package:magcloud_app/view/page/settings_view/application_info_view.dart';
import 'package:magcloud_app/view/page/settings_view/font_setting_view.dart';
import 'package:magcloud_app/view/page/settings_view/language_setting_view.dart';
import 'package:magcloud_app/view/navigator_view.dart';
import 'package:magcloud_app/view/page/settings_view/notification_config_view.dart';
import 'package:magcloud_app/view/page/splash_view.dart';
import 'package:magcloud_app/view/page/webview_view.dart';

class GlobalRoute {
  static final observer = CommonRouteObserver();
  static final routes = {
    '/login': () => LoginView(),
    '/navigator': () => NavigatorView(),
    '/settings/language': () => LanguageSettingView(),
    '/settings/font': () => FontSettingView(),
    '/settings/notification': () => NotificationConfigView(),
    '/settings/app-info': () => ApplicationInfoView()
  };

  static Future<void> fadeRoute(String target) async {
    final routeBuilder = routes[target];
    await Get.off(routeBuilder,
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 80));
  }

  static Future<void> rightToLeftRouteTo(String target) async {
    final routeBuilder = routes[target];
    await Get.to(routeBuilder, transition: Transition.rightToLeft, popGesture: true);
  }

  static Future<void> back() async {
    Get.back();
  }

  static Future<void> untilNavigator() async {
    Get.until((route) => route.settings.name == '/NavigatorView');
  }

  static Future<void> refresh() async {
    final currentRoute = Get.routing.route! as GetPageRoute;

    //Get.global(null).currentState!.pop();
    // Get.off(currentRoute.page!, preventDuplicates: false, transition: Transition.noTransition);
  }

  static Future<void> splash() async {
    Get.to(SplashView(), transition: Transition.fadeIn);
  }

  static void goMain() {
    fadeRoute('/navigator');
  }

  static Future<void> privacyPage() async {
    if(!isOnline()) {
      SnackBarUtil.errorSnackBar(message: message('message_offline_cannot_use_that'));
      return;
    }
    await Get.to(WebViewScreenView('https://bsc-webview.chuyong.kr/privacy'), transition: Transition.rightToLeft, popGesture: true);
  }

  static Future<void> noticePage() async {
    if(!isOnline()) {
      SnackBarUtil.errorSnackBar(message: message('message_offline_cannot_use_that'));
      return;
    }
    await Get.to(WebViewScreenView('https://bsc-webview.chuyong.kr/notice'), transition: Transition.rightToLeft, popGesture: true);
  }

  static bool isOnline() => inject<OnlineService>().isOnlineMode();

}

class CommonRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final Set<String> previousRoutes = HashSet();
  void _saveScreenView(
      {PageRoute<dynamic>? oldRoute,
        PageRoute<dynamic>? newRoute,
        String? routeType}) {
    debugPrint(
        '[track] ${routeType} screen old : ${oldRoute?.settings.name}, new : ${newRoute?.settings.name}');
  }

  PageRoute? checkPageRoute(Route<dynamic>? route) {
    return (route is PageRoute) ? route : null;
  }

  bool hasRoute(String routeName) => previousRoutes.contains(routeName);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    final name = route.settings.name;
    if(name != null) {
      previousRoutes.add(name);
    }

    _saveScreenView(
      newRoute: checkPageRoute(route),
      oldRoute: checkPageRoute(previousRoute),
      routeType: 'push',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    previousRoutes.clear();
    final name = newRoute?.settings.name;
    if(name != null) {
      previousRoutes.add(name);
    }

    _saveScreenView(
      newRoute: checkPageRoute(newRoute),
      oldRoute: checkPageRoute(oldRoute),
      routeType: 'replace',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    final name = route.settings.name;
    if(name != null) {
      final res = previousRoutes.remove(name);
      if(!res) print("Unexpected pop");
    }

    _saveScreenView(
      newRoute: checkPageRoute(previousRoute),
      oldRoute: checkPageRoute(route),
      routeType: 'pop',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    final name = route.settings.name;
    if(name != null) {
      final res = previousRoutes.remove(name);
      if(!res) print("Unexpected remove");
    }

    _saveScreenView(
      newRoute: checkPageRoute(route),
      oldRoute: checkPageRoute(previousRoute),
      routeType: 'remove',
    );
  }
}


