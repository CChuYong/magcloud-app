import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magcloud_app/core/service/auth_service.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/view/dialog/new_user_dialog.dart';
import 'package:magcloud_app/view/page/feed_view.dart';

import 'component/navigation_bar.dart';
import 'designsystem/base_color.dart';
import 'page/calendar_view/calendar_base_view.dart';
import 'page/friend_view.dart';
import 'page/more_view.dart';

class NavigatorView extends StatefulWidget {
  NavigatorView({super.key});

  static Map<int, Widget> widgetMap = HashMap();
  static Map<int, StatelessWidget Function(NavigatorViewState)> pageBuilder = {
    0: (e) => FeedView(e),
    1: (e) => CalendarBaseView(),
    3: (e) => MoreView(),
    2: (e) => FriendView(),
  };

  Widget getOrCreateWidget(NavigatorViewState state, int index) {
    Widget? lastWidget = widgetMap[index];
    if (lastWidget == null) {
      print("Create New Page");
      lastWidget = pageBuilder[index]!(state);
      widgetMap[index] = lastWidget;
    }
    return lastWidget;
  }

  @override
  State createState() => NavigatorViewState();
}

class NavigatorViewState extends State<NavigatorView> {
  int currentPage = 0;
  bool forwardAction = false;
  bool animationStart = false;
  final Duration navigateDuration = const Duration(milliseconds: 80);

  @override
  void initState() {
    super.initState();
    final authService = inject<AuthService>();
    if(authService.isNewUser) {
      authService.isNewUser = false;
      Future.delayed(Duration(seconds: 1), () => openNewUserDialog());
    }
  }

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

  bool isPageInitialized(int number) => NavigatorView.widgetMap.containsKey(number);

  Widget getCurrentPage() => widget.getOrCreateWidget(this, currentPage);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: BaseColor.warmGray100,
    ));
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
