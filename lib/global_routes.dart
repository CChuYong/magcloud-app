import 'package:get/get.dart';
import 'package:magcloud_app/view/page/calendar_view/calendar_base_view.dart';
import 'package:magcloud_app/view/page/friend_view.dart';
import 'package:magcloud_app/view/page/more_view.dart';

class GlobalRoute {
  static final routes = {
    '/calendar': () => const CalendarBaseView(),
    '/more': () => const MoreView(),
    '/friends': () => const FriendView()
  };

  static Future<void> horizontalRoute(String target, bool forward) async {
    final routeBuilder = routes[target];
    await Get.off(routeBuilder,
        transition: !forward ? Transition.leftToRight : Transition.rightToLeft);
  }

  static Future<void> fadeRoute(String target) async {
    final routeBuilder = routes[target];
    await Get.off(routeBuilder,
        transition: Transition.fadeIn, duration: Duration(milliseconds: 100));
  }
}
