import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:magcloud_app/core/util/extension.dart';
import 'package:magcloud_app/view/page/calendar_view/calendar_base_view.dart';
import 'package:magcloud_app/view/page/friend_view.dart';
import 'package:magcloud_app/view/page/login_view.dart';
import 'package:magcloud_app/view/page/more_view.dart';
import 'package:magcloud_app/view/page/settings_view/application_info_view.dart';
import 'package:magcloud_app/view/page/settings_view/font_setting_view.dart';
import 'package:magcloud_app/view/page/settings_view/language_setting_view.dart';
import 'package:magcloud_app/view_model/navigator_view.dart';

class GlobalRoute {
  static final observer = CommonRouteObserver();
  static final routes = {
    '/calendar': () => CalendarBaseView(),
    '/more': () => const MoreView(),
    '/friends': () => const FriendView(),
    '/login': () => LoginView(),
    '/settings/language': () => LanguageSettingView(),
    '/settings/font': () => const FontSettingView(),
    '/settings/app-info': () => const ApplicationInfoView()
  };

  static Future<void> horizontalRoute(String target, bool forward) async {
    final routeBuilder = routes[target];
    await Get.off(routeBuilder,
        transition: !forward ? Transition.leftToRight : Transition.rightToLeft);
  }

  static Future<void> fadeRoute(String target) async {
    final routeBuilder = routes[target];
    await Get.off(routeBuilder,
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 80));
  }

  static Future<void> route(String target) async {
    final routeBuilder = routes[target];
    await Get.off(routeBuilder, transition: Transition.noTransition);
  }

  static Future<void> routeTo(String target) async {
    final routeBuilder = routes[target];
    await Get.to(routeBuilder, transition: Transition.noTransition);
  }

  static Future<void> fadeRouteTo(String target) async {
    final routeBuilder = routes[target];
    await Get.to(routeBuilder,   transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 80));
  }

  static Future<void> rightToLeftRouteTo(String target) async {
    final routeBuilder = routes[target];
    await Get.to(routeBuilder, transition: Transition.rightToLeft, popGesture: true);
  }

  static Future<void> back() async {
    Get.back();
  }

  static Future<void> refresh() async {
    final currentRoute = Get.routing.route! as GetPageRoute;

    //Get.global(null).currentState!.pop();
    // Get.off(currentRoute.page!, preventDuplicates: false, transition: Transition.noTransition);
  }

  static void goMain() {
    Get.off(NavigatorView());
  }

  static void test(String target){
    final routeBuilder = routes[target];
    final name = _cleanRouteName(routeBuilder.runtimeType.toString());
    if(observer.hasRoute(name)) {
      print('잇음');
      Get.until((route) {
        if(route is GetPageRoute) {
          return route.routeName == name;
        }
        return false;
      });
    } else{
      print('$name djq음');
      Get.to(routeBuilder);
    }
  }

  static String _cleanRouteName(String name) {
    name = name.replaceAll('() => ', '');

    /// uncommonent for URL styling.
    // name = name.paramCase!;
    if (!name.startsWith('/')) {
      name = '/$name';
    }
    return Uri.tryParse(name)?.toString() ?? name;
  }

  static Future<bool> isCurrentRouteFirst() {
    var completer = Completer<bool>();

    return completer.future;
  }

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


