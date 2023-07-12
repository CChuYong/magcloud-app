import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: BaseColor.warmGray200,
              width: 1,
            ),
          ),
        ),
        child: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              backgroundColor: BaseColor.defaultBackgroundColor,
              selectedItemColor: BaseColor.warmGray700,
              unselectedItemColor: BaseColor.warmGray400,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedFontSize: 0,
              unselectedFontSize: 0,
              unselectedIconTheme:
                  IconThemeData(color: BaseColor.warmGray400, size: 24.sp),
              selectedIconTheme:
                  IconThemeData(color: BaseColor.warmGray800, size: 24.sp),
              selectedLabelStyle: TextStyle(
                fontSize: 0,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 0,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.cloud, size: iconSize),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month, size: iconSize),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_alt, size: iconSize),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu, size: iconSize),
                  label: '',
                ),
              ],
              type: BottomNavigationBarType.fixed,
              currentIndex: widget.currentPage,
              onTap: widget.onTap,
              enableFeedback: false,
            )));
  }
}
