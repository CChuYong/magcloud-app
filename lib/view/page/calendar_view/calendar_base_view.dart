import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/core/model/daily_user.dart';
import 'package:magcloud_app/core/util/extension.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';
import 'package:magcloud_app/view/designsystem/base_icon.dart';

import '../../../core/model/mood.dart';
import '../../../core/util/i18n.dart';
import '../../../view_model/calendar_view/calendar_base_view_model.dart';
import '../../../view_model/calendar_view/calendar_base_view_state.dart';
import '../../designsystem/base_color.dart';

class CalendarBaseView extends BaseView<CalendarBaseView, CalendarBaseViewModel,
    CalendarBaseViewState> {
  CalendarBaseView({super.key});

  @override
  bool isAutoRemove() => false;

  @override
  Color navigationBarColor() => BaseColor.warmGray100;

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
    return Container(
      color: BaseColor.defaultBackgroundColor,
      child: Stack(
        children: [
          SafeArea(
              child: AnimatedPadding(
                  padding: EdgeInsets.only(
                      top: action.isFriendBarOpen ? 130.sp : 45.sp),
                  curve: curve,
                  duration: aniamtionDuration,
                  child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onVerticalDragEnd: action.onVerticalDrag,
                      onHorizontalDragEnd: action.onHorizontalDrag,
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
                      )))),
          Container(
            width: double.infinity,
            height: 50.sp,
            color: BaseColor.defaultBackgroundColor,
          ),
          SafeArea(
              child: GestureDetector(
                  onVerticalDragEnd: action.onVerticalDragTopBar,
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
                                  Container(
                                    color: BaseColor.defaultBackgroundColor,
                                    child: friendBar(action),
                                  ),
                                ],
                              )
                            : Container(),
                      ),
                      Container(
                        color: BaseColor.defaultBackgroundColor,
                        child: Divider(color: BaseColor.warmGray200),
                      ),
                    ],
                  ))),
        ],
      ),
      //  ),
    );
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
                  onTap: () => action.toggleOnline(),
                  child: Text(
                    action.isFriendBarOpen
                        ? message("navigation_calendar")
                        : (action.isMeSelected()
                            ? message("magcloud_with_me")
                            : message("magcloud_with_name").format(
                                [action.state.selectedUser?.name ?? ''])),
                    style: TextStyle(
                        color: BaseColor.warmGray800,
                        fontSize: action.isFriendBarOpen ? 22.sp : 20.sp,
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
    final isOnline = action.isOnline();
    return IntrinsicHeight(
        child: Row(
      children: [
        Expanded(
            child: Stack(
          alignment: Alignment.center,
          // fit: StackFit.expand,
          children: [
            Container(
              color: BaseColor.defaultBackgroundColor,
              width: double.infinity,
              height: 69.sp,
              child:
                  CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal, slivers: [
                SliverToBoxAdapter(child: SizedBox(width: 15.sp)),
                SliverToBoxAdapter(child: meIcon(action, action.state.dailyMe)),
                SliverToBoxAdapter(child: SizedBox(width: 10.sp)),
                for (DailyUser user in action.state.dailyFriends) ...[
                  SliverToBoxAdapter(child: friendIcon(action, user)),
                  SliverToBoxAdapter(child: SizedBox(width: 10.sp)),
                ],
                SliverToBoxAdapter(child: addFriend(action)),
                SliverToBoxAdapter(child: SizedBox(width: 15.sp)),
              ]),
            ),
            isOnline
                ? Container()
                : ClipRect(
                    child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      width: double.infinity,
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
                  )),
          ],
        ))
      ],
    ));
  }

  Widget friendProfileIcon(Color color, String? url, bool isSelected) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: isSelected ? 42.sp : 40.sp,
          height: isSelected ? 42.sp : 40.sp,
          decoration: BoxDecoration(
            color: BaseColor.defaultBackgroundColor,
            shape: BoxShape.circle,
            image: url != null
                ? DecorationImage(
                    image: CachedNetworkImageProvider(url),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),
        Container(
          width: isSelected ? 50.sp : 48.sp,
          height: isSelected ? 50.sp : 48.sp,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3.0),
          ),
        )
      ],
    );
  }

  Widget addFriend(CalendarBaseViewModel action) {
    return TouchableOpacity(
        onTap: action.onTapAddFriend,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 40.sp,
                  height: 40.sp,
                  decoration: BoxDecoration(
                    color: BaseColor.warmGray100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add),
                ),
                Container(
                  width: 48.sp,
                  height: 48.sp,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: BaseColor.warmGray300, width: 3.0),
                  ),
                )
              ],
            ),
            Text(
              message('generic_add_friend'),
              style: TextStyle(
                color: BaseColor.warmGray500,
                fontSize: 12.sp,
              ),
            ),
          ],
        ));
  }

  Widget friendIcon(CalendarBaseViewModel action, DailyUser user) {
    final isSelected = action.state.selectedUser == user;
    return TouchableOpacity(
        onTap: () => action.onTapFriendIcon(user),
        child: Container(
            width: 54.sp,
            child: Column(
              children: [
                friendProfileIcon(user.mood.moodColor, user.profileImageUrl, isSelected),
                Text(
                  user.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: isSelected ? BaseColor.warmGray700 : BaseColor.warmGray500,
                      fontSize: isSelected ? 13.sp : 11.sp,
                  ),
                ),
              ],
            )));
  }

  Widget meIcon(CalendarBaseViewModel action, DailyUser? me) {
    final mood = me?.mood ?? Mood.neutral;
    final isSelected = action.state.selectedUser == me;
    return TouchableOpacity(
        onTap: () => me?.let(action.onTapFriendIcon),
        child:  Container(
            width: 54.sp,
    child:Column(
          children: [
            friendProfileIcon(mood.moodColor, me?.profileImageUrl, action.state.selectedUser == me),
            Text(
              message('generic_me'),
              style: TextStyle(
                color: isSelected ? BaseColor.warmGray700 : BaseColor.warmGray500,
                fontSize: isSelected ? 13.sp : 11.sp,
              )
            ),
          ],
        )));
  }
}
