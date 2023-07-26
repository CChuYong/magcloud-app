import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/core/model/friend.dart';
import 'package:magcloud_app/core/util/extension.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';

import '../../view_model/friend_view/friend_view_model.dart';
import '../../view_model/friend_view/friend_view_state.dart';
import '../designsystem/base_color.dart';
import '../navigator_view.dart';

class FriendView
    extends BaseView<FriendView, FriendViewModel, FriendViewState> {
  final NavigatorViewState navigator;
  FriendView(this.navigator, {super.key});

  @override
  bool isAutoRemove() => false;

  @override
  FriendViewModel initViewModel() => FriendViewModel(navigator);

  @override
  Color navigationBarColor() => BaseColor.warmGray100;

  @override
  Widget render(
      BuildContext context, FriendViewModel action, FriendViewState state) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.sp),
          titleBar(context, action),
          SizedBox(height: 14.sp),
          searchBar(context, action),
          SizedBox(height: 5.sp),
          Divider(color: context.theme.colorScheme.outline),
          Expanded(child: friendContainer(context, action, state))
        ],
      ),
    );
  }

  Widget titleBar(BuildContext context, FriendViewModel action) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              message('navigation_friends'),
              style: TextStyle(
                  color: context.theme.colorScheme.primary,
                  fontSize: 22.sp,
                  fontFamily: 'GmarketSans'),
            ),
            TouchableOpacity(
                onTap: action.onTapAddFriend,
                child: Container(
                    width: 31.sp,
                    height: 33.sp,
                    //  color: BaseColor.blue300,
                    child: Stack(alignment: Alignment.centerLeft, children: [
                      Icon(Icons.people,
                          color: context.theme.colorScheme.secondary, size: 24.sp),
                      action.state.requestCount != 0
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: BaseColor.red400,
                                ),
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.sp, horizontal: 3.sp),
                                    child: Text(
                                        action.state.requestCount.toString(),
                                        style: TextStyle(
                                          color: BaseColor.warmGray50,
                                          fontSize: 12.sp,
                                          height: 1.0,
                                        ))),
                              ))
                          : Container()
                    ])))
          ],
        ));
  }

  Widget searchBar(BuildContext context, FriendViewModel action) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: context.theme.colorScheme.onBackground,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.sp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 20.sp, color: BaseColor.warmGray300),
                SizedBox(width: 8.sp),
                Expanded(
                    child: TextField(
                  controller: action.searchController,
                  focusNode: action.focusNode,
                  onTapOutside: (e) {
                    action.focusNode.unfocus();
                  },
                  style: TextStyle(
                    color: context.theme.colorScheme.secondary,
                    fontSize: 15.sp,
                    height: 1.2,
                  ),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: message('generic_search'),
                      hintStyle: TextStyle(
                        color: context.theme.colorScheme.secondary,
                        fontSize: 15.sp,
                      )),
                ))
              ],
            ),
          ),
        ));
  }

  Widget friendContainer(BuildContext context, FriendViewModel action, FriendViewState state) {
    final friends = state.getFilteredFriends();
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 17.sp, vertical: 3.sp),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                onRefresh: action.reloadFriends,
                child: CustomScrollView(
                  controller: action.scrollController,
                    reverse: false,
                    slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate(
                          friends.map((e) => friendBox(context, e)).toList())),
                  SliverToBoxAdapter(child: SizedBox(height: 8.sp)),
                  SliverToBoxAdapter(
                      child: Center(
                          child: Text(
                    message('message_total_friend_count')
                        .format([friends.length.toString()]),
                    style: TextStyle(
                      color: context.theme.colorScheme.secondary,
                      fontSize: 12.sp,
                    ),
                  )))
                ]),
              ),
            ),
          ],
        ));
  }

  Widget friendBox(BuildContext context, Friend friend) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            TouchableOpacity(
                onTap: () => action.onTapFriend(friend),
                child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Container(
                          width: 42.sp,
                          height: 42.sp,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    friend.profileImageUrl),
                                fit: BoxFit.cover,
                              ),
                              color: BaseColor.warmGray700,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: context.theme.colorScheme.outline, width: 0.5)),
                        ),
                        SizedBox(width: 10.sp),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              friend.name,
                              style: TextStyle(
                                color: context.theme.colorScheme.primary,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              friend.nameTag,
                              style: TextStyle(
                                color: context.theme.colorScheme.secondary,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ))),
            Positioned(
                right: 0,
                child: Row(
                  children: [
                    friend.isDiaryShared
                        ? TouchableOpacity(
                            onTap: () => action.onTapUnShareDiary(friend),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: BaseColor.warmGray300),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.sp, horizontal: 7.sp),
                                child: Text(
                                  message('generic_friend_unshare_diary'),
                                  style: TextStyle(
                                    color: BaseColor.warmGray700,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ))
                        : TouchableOpacity(
                            onTap: () => action.onTapShareDiary(friend),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: BaseColor.green200),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.sp, horizontal: 7.sp),
                                child: Text(
                                  message('generic_friend_share_diary'),
                                  style: TextStyle(
                                    color: BaseColor.warmGray700,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            )),
                    SizedBox(width: 5.sp),
                    TouchableOpacity(
                        onTap: () => action.onTapDeleteFriend(friend),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: BaseColor.red300),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.sp, horizontal: 7.sp),
                            child: Text(
                              message('generic_friend_delete'),
                              style: TextStyle(
                                color: BaseColor.warmGray700,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ))
                  ],
                ))
          ],
        ),
        SizedBox(height: 8.sp),
      ],
    );
  }
}
