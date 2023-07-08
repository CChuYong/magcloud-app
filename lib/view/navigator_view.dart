import 'dart:collection';

import 'package:flutter/material.dart';

import 'component/navigation_bar.dart';
import 'designsystem/base_color.dart';
import 'page/calendar_view/calendar_base_view.dart';
import 'page/friend_view.dart';
import 'page/more_view.dart';

class NavigatorView extends StatefulWidget {
  NavigatorView({super.key});

  final Map<int, Widget> widgetMap = HashMap();
  static final pageBuilder = {
    1: () => CalendarBaseView(),
    2: () => MoreView(),
    0: () => FriendView(),
  };

  Widget getOrCreateWidget(int index) {
    Widget? lastWidget = widgetMap[index];
    if (lastWidget == null) {
      print("Create New Page");
      lastWidget = pageBuilder[index]!();
      widgetMap[index] = lastWidget;
    }
    return lastWidget;
  }

  @override
  State createState() => _NavigatorViewState();
}

class _NavigatorViewState extends State<NavigatorView> {
  int currentPage = 1;
  bool forwardAction = false;
  bool animationStart = false;
  final Duration navigateDuration = const Duration(milliseconds: 80);

  double getAnimationOffset() {
    const ratio = 0.1;
    if (animationStart) {
      animationStart = false;
      return forwardAction ? -1 * ratio : ratio;
    } else {
      return forwardAction ? ratio : -1 * ratio;
    }
  }

  void onTap(int number) {
    if (currentPage == number) return;
    animationStart = true;
    forwardAction = currentPage < number;
    setState(() {
      currentPage = number;
    });
  }

  Widget getCurrentPage() => widget.getOrCreateWidget(currentPage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColor.defaultBackgroundColor,
      bottomNavigationBar:
          BaseNavigationBar(onTap: onTap, currentPage: currentPage),
      body: AnimatedSwitcher(
        duration: navigateDuration,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(getAnimationOffset(), 0.0),
                // adjust the position as you need
                end: const Offset(0.0, 0.0),
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ));
        },
        child: getCurrentPage(),
      ),
    );
  }
}
