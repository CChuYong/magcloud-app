import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/global_routes.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';

class BaseNavigationBar extends StatefulWidget {
  void Function()? onTapSelf;

  BaseNavigationBar({this.onTapSelf});

  @override
  State<StatefulWidget> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<BaseNavigationBar> {
  final iconSize = 24.sp;
  final fontSize = 10.sp;

  void _setPage(int index) async {
    await GlobalRoute.fadeRouteTo(pageToRoute(index));
  }

  int routeToPage(String route) {
    switch (route) {
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
    switch (page) {
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

  void onTapNavigation(int number) {
    if (number != currentPage())
      _setPage(number);
    else {
      if (widget.onTapSelf != null) widget.onTapSelf!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: BaseColor.warmGray100,
      selectedItemColor: BaseColor.warmGray700,
      unselectedItemColor: BaseColor.warmGray300,
      unselectedIconTheme:
          IconThemeData(color: BaseColor.warmGray300, size: 24.sp),
      selectedIconTheme:
          IconThemeData(color: BaseColor.warmGray700, size: 24.sp),
      selectedLabelStyle: TextStyle(
        fontSize: fontSize,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: fontSize,
      ),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt, size: iconSize),
          label: message("navigation_friends"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: iconSize),
          label: message("navigation_calendar"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu, size: iconSize),
          label: message("navigation_more"),
        )
      ],
      currentIndex: currentPage(),
      onTap: onTapNavigation,
    );
  }

  int currentPage() => routeToPage(Get.currentRoute);
}
