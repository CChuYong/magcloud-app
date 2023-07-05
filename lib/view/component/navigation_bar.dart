import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';

class BaseNavigationBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<BaseNavigationBar> {
  final iconSize = 24.sp;
  final fontSize = 10.sp;
  int _currentPage = 1;


  void _setPage(int index) async {
    setState(() {
      _currentPage = index;
    });
    await Get.offNamed(pageToRoute(index));
  }

  int routeToPage(String route) {
    switch(route) {
      case "/friends":
        return 0;
      case "/calendar":
        return 1;
      case "/more":
        return 2;
      default:
        return 1;
    }
  }

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
            label: '내 친구',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, size: iconSize),
            label: '달력',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu, size: iconSize),
            label: '더보기',
          )
        ],
      currentIndex: _currentPage,
      onTap: (number) => {if (number != _currentPage) _setPage(number)},
    );
  }

}
