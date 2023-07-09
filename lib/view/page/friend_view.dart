import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/core/model/friend.dart';
import 'package:magcloud_app/core/model/user.dart';
import 'package:magcloud_app/core/util/extension.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';

import '../../view_model/friend_view/friend_view_model.dart';
import '../../view_model/friend_view/friend_view_state.dart';
import '../designsystem/base_color.dart';

class FriendView
    extends BaseView<FriendView, FriendViewModel, FriendViewState> {
  FriendView({super.key});

  @override
  bool isAutoRemove() => false;

  @override
  FriendViewModel initViewModel() => FriendViewModel();

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
          titleBar(action),
          SizedBox(height: 14.sp),
          searchBar(action),
          SizedBox(height: 5.sp),
          Divider(color: BaseColor.warmGray200),
          Expanded(child: friendContainer(action, state))
        ],
      ),
    );
  }

  Widget titleBar(FriendViewModel action) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              message('navigation_friends'),
              style: TextStyle(
                  color: BaseColor.warmGray700,
                  fontSize: 22.sp,
                  fontFamily: 'GmarketSans'),
            ),
            TouchableOpacity(
                onTap: action.onTapAddFriend,
                child: Icon(Icons.people, color: BaseColor.warmGray700))
          ],
        ));
  }

  Widget searchBar(FriendViewModel action) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: BaseColor.warmGray100,
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
                  onTapOutside: (e) { action.focusNode.unfocus(); },
                  style: TextStyle(
                    color: BaseColor.warmGray600,
                    fontSize: 15.sp,
                    height: 1.2,
                  ),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: message('generic_search'),
                      hintStyle: TextStyle(
                        color: BaseColor.warmGray400,
                        fontSize: 15.sp,
                      )),
                ))
              ],
            ),
          ),
        ));
  }

  Widget friendContainer(FriendViewModel action, FriendViewState state) {
    final friends = state.getFilteredFriends();
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 17.sp, vertical: 10.sp),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                onRefresh: action.reloadFriends,
                child: CustomScrollView(reverse: false, slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate(
                          friends.map(friendBox).toList())),
                  SliverToBoxAdapter(child: SizedBox(height: 8.sp)),
                  SliverToBoxAdapter(
                      child: Center(
                          child: Text(
                    message('message_total_friend_count')
                        .format([friends.length.toString()]),
                    style: TextStyle(
                      color: BaseColor.warmGray500,
                      fontSize: 12.sp,
                    ),
                  )))
                ]),
              ),
            ),
            SizedBox(height: 8.sp),
          ],
        ));
  }

  Widget friendBox(Friend friend) {
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
                                  color: BaseColor.warmGray300, width: 0.5)),
                        ),
                        SizedBox(width: 10.sp),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              friend.name,
                              style: TextStyle(
                                color: BaseColor.warmGray700,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              friend.nameTag,
                              style: TextStyle(
                                color: BaseColor.warmGray500,
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
