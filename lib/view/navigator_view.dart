import 'dart:collection';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:magcloud_app/core/api/open_api.dart';
import 'package:magcloud_app/core/service/auth_service.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/global_routes.dart';
import 'package:magcloud_app/view/dialog/confirm_dialog.dart';
import 'package:magcloud_app/view/dialog/new_user_dialog.dart';
import 'package:magcloud_app/view/page/feed_view.dart';

import '../core/service/notification_service.dart';
import '../core/util/debouncer.dart';
import 'component/navigation_bar.dart';
import 'designsystem/base_color.dart';
import 'dialog/comment_list_dialog.dart';
import 'page/calendar_view/calendar_base_view.dart';
import 'page/friend_view.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';
import 'page/more_view.dart';

class NavigatorView extends StatefulWidget {
  NavigatorView({super.key});

  static Map<int, Widget> widgetMap = HashMap();
  static Map<int, StatelessWidget Function(NavigatorViewState)> pageBuilder = {
    0: (e) => FeedView(e),
    1: (e) => CalendarBaseView(),
    3: (e) => MoreView(),
    2: (e) => FriendView(e),
  };
  static void clearAll() {
    print("clearing navigator routes");
    widgetMap.clear();
  }

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
  void Function()? onTapSelf;

  @override
  void initState() {
    super.initState();
    final authService = inject<AuthService>();
    if (authService.isNewUser) {
      authService.isNewUser = false;
      Future.delayed(Duration(seconds: 1), () => openNewUserDialog());
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotification);
    final notificationService = inject<NotificationService>();
    if (notificationService.initialMessage != null) {
      _handleNotification(notificationService.initialMessage!);
      notificationService.initialMessage = null;
    }
  }

  void _handleNotification(RemoteMessage message) async {
    if (message.data.containsKey("routePath")) {
      final routePath = message.data["routePath"] as String;
      print("Handle $routePath");
      if (GlobalRoute.routes.containsKey(routePath)) {
        GlobalRoute.rightToLeftRouteTo(routePath);
      } else if (routePath.startsWith("/friend")) {
        final subPath = routePath.split("/").last;
        GlobalRoute.friendProfileView(subPath);
        //onTap(2);
      } else if (routePath.startsWith("/feed")) {
        onTap(0);
      } else  if (routePath.startsWith("/comment")) {
        final diaryId = routePath.split("/").last;
        final comments = await inject<OpenAPI>().getDiaryComments(diaryId);
        openCommentListDialog(diaryId, comments);
      }
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
    if(number > 3 || number < 0) return;
    if (currentPage == number) {
      onTapSelf?.call();
      return;
    }
    onTapSelf = null;
    animationStart = true;
    forwardAction = currentPage < number;
    setState(() {
      currentPage = number;
    });
  }

  bool isPageInitialized(int number) =>
      NavigatorView.widgetMap.containsKey(number);

  Widget getCurrentPage() => widget.getOrCreateWidget(this, currentPage);

  final Debouncer dragDebouncer = Debouncer(const Duration(milliseconds: 25));

  void onHorizontalDrag(DragEndDetails details) {
    dragDebouncer.runLastCall(() {
      final isPositive = (details.primaryVelocity ?? 0) < 0;
      if(isPositive) {
        onTap(currentPage + 1);
      } else {
        onTap(currentPage - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollsToTop(
      onScrollsToTop: (e) async => onTapSelf?.call(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
      systemNavigationBarColor: context.theme.colorScheme.background,
      statusBarColor: context.theme.colorScheme.onBackground,
      statusBarIconBrightness: Get.isDarkMode ? Brightness.light : Brightness.dark,
      statusBarBrightness: Get.isDarkMode ? Brightness.dark : Brightness.light,
      ),
      child: WillPopScope(
        onWillPop: () async {
          return await confirmDialog(
              message('generic_exit_title'),
              message('generic_exit_subtitle'),
              confirmText: message('generic_exit_confirm'));
        },
          child: Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      bottomNavigationBar:
          BaseNavigationBar(onTap: onTap, currentPage: currentPage),
      body: GestureDetector(
    onHorizontalDragEnd: onHorizontalDrag,
    child: AnimatedSwitcher(
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
        child:  getCurrentPage()
    )
        ,
      ),
    ))));
  }
}
