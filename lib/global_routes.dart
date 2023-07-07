import 'package:get/get.dart';
import 'package:magcloud_app/view/page/calendar_view/calendar_base_view.dart';
import 'package:magcloud_app/view/page/friend_view.dart';
import 'package:magcloud_app/view/page/login_view.dart';
import 'package:magcloud_app/view/page/more_view.dart';
import 'package:magcloud_app/view/page/settings_view/font_setting_view.dart';
import 'package:magcloud_app/view/page/settings_view/language_setting_view.dart';

class GlobalRoute {
  static final routes = {
    '/calendar': () => CalendarBaseView(),
    '/more': () => const MoreView(),
    '/friends': () => const FriendView(),
    '/login': () => LoginView(),
    '/settings/language': () => LanguageSettingView(),
    '/settings/font': () => FontSettingView(),
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

  static Future<void> back() async {
    Get.back();
  }

  static Future<void> refresh() async {
    final currentRoute = Get.routing.route! as GetPageRoute;
    //Get.global(null).currentState!.pop();
    // Get.off(currentRoute.page!, preventDuplicates: false, transition: Transition.noTransition);
  }
}
