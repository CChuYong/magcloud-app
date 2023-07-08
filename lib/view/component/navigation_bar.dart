import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';

class BaseNavigationBar extends StatefulWidget {
  void Function()? onTapSelf;
  void Function(int)? onTap;
  final int currentPage;

  BaseNavigationBar({this.onTapSelf, this.onTap, required this.currentPage});

  @override
  State<StatefulWidget> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<BaseNavigationBar> {
  final iconSize = 24.sp;
  final fontSize = 10.sp;

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
      currentIndex: widget.currentPage,
      onTap: widget.onTap,
    );
  }
}
