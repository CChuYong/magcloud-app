import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/core/model/daily_user.dart';
import 'package:magcloud_app/core/service/online_service.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';
import 'package:magcloud_app/view/designsystem/base_icon.dart';

import '../../../core/model/user.dart';
import '../../../core/util/i18n.dart';
import '../../../view_model/calendar_view/calendar_base_view_model.dart';
import '../../../view_model/calendar_view/calendar_base_view_state.dart';
import '../../component/navigation_bar.dart';
import '../../designsystem/base_color.dart';

class CalendarBaseView extends BaseView<CalendarBaseView, CalendarBaseViewModel,
    CalendarBaseViewState> {
  CalendarBaseView({super.key});

  final Duration aniamtionDuration = Duration(milliseconds: 200);

  double getAnimationOffset(CalendarBaseViewModel action) {
    final initialRate = 0.3;
    if (action.verticalAnimationStart) {
      action.verticalAnimationStart = false;
      return action.verticalForwardAction ? -1 * initialRate : initialRate;
    } else {
      return action.verticalForwardAction ? initialRate : -1 * initialRate;
    }
  }

  @override
  CalendarBaseViewModel initViewModel() => CalendarBaseViewModel();

  @override
  Widget render(BuildContext context, CalendarBaseViewModel action,
      CalendarBaseViewState state) {
    const Curve curve = Curves.easeInOutSine;
    return Scaffold(
        backgroundColor: BaseColor.defaultBackgroundColor,
        bottomNavigationBar: BaseNavigationBar(),
        body: Container(
          color: BaseColor.defaultBackgroundColor,
          child: Stack(
            children: [
              SafeArea(
                  child: AnimatedPadding(
                      padding: EdgeInsets.only(
                          top: action.isFriendBarOpen ? 130.sp : 45.sp),
                      curve: curve,
                      duration: aniamtionDuration,
                      child: Column(
                        children: [
                          Expanded(
                              child: AnimatedSwitcher(
                            duration: aniamtionDuration,
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                        begin: Offset(
                                            0.0, getAnimationOffset(action)),
                                        end: const Offset(0.0, 0.0))
                                    .animate(animation),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: action.getRoutedWidgetBuilder()(),
                          ))
                        ],
                      ))),
              Container(
                width: double.infinity,
                height: 50.sp,
                color: BaseColor.defaultBackgroundColor,
              ),
              SafeArea(
                  child: Column(
                children: [
                  titleBar(action),
                  AnimatedSwitcher(
                    switchInCurve: curve,
                    switchOutCurve: curve,
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return SizeTransition(
                        sizeFactor: animation,
                        axis: Axis.vertical,
                        axisAlignment: -1,
                        child: child,
                      );
                    },
                    child: action.isFriendBarOpen
                        ? Column(
                            children: [
                              Container(
                                  color: BaseColor.defaultBackgroundColor,
                                  height: 18.sp,
                                  width: double.infinity),
                              friendBar(action),
                            ],
                          )
                        : Container(),
                  ),
                  Container(
                    color: BaseColor.defaultBackgroundColor,
                    child: Divider(color: BaseColor.warmGray200),
                  ),
                ],
              )),
            ],
          ),
          //  ),
        ));
  }

  Widget titleBar(CalendarBaseViewModel action) {
    return Container(
      color: BaseColor.defaultBackgroundColor,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TouchableOpacity(
                onTap: () => OnlineService.invokeOnlineToggle(),
                  child: Text(
                message("magcloud"),
                style: TextStyle(
                    color: BaseColor.warmGray800,
                    fontSize: 22.sp,
                    fontFamily: 'GmarketSans'),
              )),
              TouchableOpacity(
                  onTap: action.toggleFriendBar,
                  child: Icon(
                      action.isFriendBarOpen
                          ? BaseIcon.arrowUp
                          : BaseIcon.arrowDown,
                      size: 22.sp)),
            ],
          )),
    );
  }

  Widget friendBar(CalendarBaseViewModel action) {
    return Stack(
      // fit: StackFit.expand,
      children: [
        Container(
          color: BaseColor.defaultBackgroundColor,
          width: double.infinity,
          height: 64.sp,
          child: CustomScrollView(scrollDirection: Axis.horizontal, slivers: [
            SliverToBoxAdapter(child: SizedBox(width: 15.sp)),
            for (DailyUser user in action.state.dailyFriends) ...[
              SliverToBoxAdapter(child: friendIcon(user)),
              SliverToBoxAdapter(child: SizedBox(width: 10.sp)),
            ],
            SliverToBoxAdapter(child: addFriend(action)),
            SliverToBoxAdapter(child: SizedBox(width: 15.sp)),
          ]),
        ),
        action.isOnline
            ? Container()
            : BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 3),
                child: Container(
                  width: double.infinity,
                  height: 64.sp,
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      message('message_offline_cannot_view_friends'),
                      style: TextStyle(
                        color: BaseColor.warmGray700,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget addFriend(CalendarBaseViewModel action) {
    return Column(
      children: [
        Container(
          width: 42.sp,
          height: 42.sp,
          decoration: BoxDecoration(
              color: BaseColor.warmGray100,
              shape: BoxShape.circle,
              border: Border.all(color: BaseColor.warmGray200, width: 2.0)),
          child: Icon(Icons.add),
        ),
        Text(
          message('generic_add_friend'),
          style: TextStyle(
            color: BaseColor.warmGray500,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget friendIcon(DailyUser user) {
    return Column(
      children: [
        Container(
          width: 42.sp,
          height: 42.sp,
          decoration: BoxDecoration(
              color: BaseColor.warmGray700,
              shape: BoxShape.circle,
              border: Border.all(color: user.diary.mood.moodColor, width: 3.0),
            image: DecorationImage(
              image: CachedNetworkImageProvider(user.profileImageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          user.name,
          style: TextStyle(
            color: BaseColor.warmGray500,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
