import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/global_routes.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';
import 'package:magcloud_app/view/page/friend_view.dart';

class BaseNavigationBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<BaseNavigationBar> {
  final iconSize = 24.sp;
  final fontSize = 10.sp;


  void _setPage(int index) async {
    final isForward = currentPage() < index;
    await GlobalRoute.horizontalRoute(pageToRoute(index), isForward);
  }

  int routeToPage(String route) {
    switch(route) {
      case "/FriendView":
        return 0;
      case "/CalendarView":
        return 1;
      case "/MoreView":
        return 2;
      default:
        return 1;
    }
  }

  String typeName(Type type) => type.toString();

  String pageToRoute(int page) {
    switch(page) {
      case 0:
        return "/friends";
      case 1:
        return "/calendar";
      case 2:
        return "/more";
      default:
        return "/calendar";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: BaseColor.warmGray300,
        selectedItemColor: BaseColor.warmGray800,
        unselectedItemColor: BaseColor.warmGray400,
        unselectedIconTheme: IconThemeData(color: BaseColor.warmGray400, size: 24.sp),
        selectedIconTheme: IconThemeData(color: BaseColor.warmGray800, size: 24.sp),
        selectedLabelStyle: TextStyle(
          fontSize: fontSize,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: fontSize,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
                Icons.people_alt, size: iconSize),
            label: message("navigation_friends"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, size: iconSize),
            label: message("navigation_calendar"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu, size: iconSize),
            label: message("navigation_more"),
          )
        ],
      currentIndex: currentPage(),
      onTap: (number) => {if (number != currentPage()) _setPage(number)},
    );
  }

  int currentPage() => routeToPage(Get.currentRoute);

}
