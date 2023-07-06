import 'package:get/get.dart';
import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/view/page/calendar_view/calendar_base_view.dart';
import 'package:magcloud_app/view/page/friend_view.dart';
import 'package:magcloud_app/view/page/login_view.dart';
import 'package:magcloud_app/view/page/more_view.dart';

class GlobalRoute {
  static final routes = {
    '/calendar': () => CalendarBaseView(),
    '/more': () => const MoreView(),
    '/friends': () => const FriendView(),
    '/login': () => LoginView(),
  };

  static Future<void> horizontalRoute(String target, bool forward) async {
    final routeBuilder = routes[target];
    await Get.off(routeBuilder,
        transition: !forward ? Transition.leftToRight : Transition.rightToLeft);
  }

  static Future<void> fadeRoute(String target) async {
    final routeBuilder = routes[target];
    await Get.off(routeBuilder,
        transition: Transition.fadeIn, duration: const Duration(milliseconds: 80));
  }

  static Future<void> route(String target) async {
    final routeBuilder = routes[target];
    await Get.off(routeBuilder,
        transition: Transition.noTransition);
  }

  static Future<void> refresh() async {
    final currentRoute = Get.routing.route! as GetPageRoute;
    //Get.global(null).currentState!.pop();
   // Get.off(currentRoute.page!, preventDuplicates: false, transition: Transition.noTransition);



  }
}
