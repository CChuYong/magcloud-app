import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/core/model/user.dart';
import 'package:magcloud_app/core/util/extension.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';

import '../../global_routes.dart';
import '../../view_model/friend_request_view/friend_request_view_model.dart';
import '../../view_model/friend_request_view/friend_request_view_state.dart';
import '../designsystem/base_color.dart';
import '../designsystem/base_icon.dart';

class FriendRequestView extends BaseView<FriendRequestView,
    FriendRequestViewModel, FriendRequestViewState> {
  FriendRequestView({super.key});

  @override
  FriendRequestViewModel initViewModel() => FriendRequestViewModel();

  @override
  Widget render(BuildContext context, FriendRequestViewModel action,
      FriendRequestViewState state) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.sp),
            titleBar(context),
            SizedBox(height: 10.sp),
            searchBar(context, action),
            SizedBox(height: 5.sp),
            Divider(color: context.theme.colorScheme.outline),
            Expanded(child: friendContainer(context, action, state))
          ],
        ),
      ),
    );
  }

  Widget titleBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TouchableOpacity(
            onTap: GlobalRoute.back,
            child: SizedBox(
                width: 47.sp,
                height: 32.sp,
                child: Align(
                    alignment: Alignment.center,
                    child: Icon(BaseIcon.arrowLeft, size: 16.sp, color: context.theme.colorScheme.secondary))),
          ),
          Text(message('generic_friend_requests'),
              style: TextStyle(
                  color: context.theme.colorScheme.primary,
                  fontSize: 16.sp,
                  fontFamily: 'Pretendard')),
          TouchableOpacity(
              onTap: action.onTapFriendAddButton,
              child: SizedBox(
                  width: 32.sp,
                  height: 32.sp,
                  child: Icon(Icons.add,
                      color: context.theme.colorScheme.secondary, size: 22.sp)))
        ],
      ),
    );
  }

  Widget searchBar(BuildContext context, FriendRequestViewModel action) {
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

  Widget friendContainer(
      BuildContext context,
      FriendRequestViewModel action, FriendRequestViewState state) {
    final requests = state.getFilteredRequests();
    final sentRequests = state.getFilteredSentRequests();
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 17.sp, vertical: 5.sp),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                onRefresh: action.reloadRequests,
                child: CustomScrollView(reverse: false, slivers: [
                  SliverToBoxAdapter(
                      child: Text(
                    message('message_received_friend_requests_size')
                        .format([state.requests.length]),
                    style: TextStyle(
                      color: context.theme.colorScheme.secondary,
                      fontSize: 12.sp,
                    ),
                  )),
                  SliverToBoxAdapter(child: SizedBox(height: 14.sp)),
                  SliverList(
                      delegate: SliverChildListDelegate(requests
                          .map((e) => receivedRequest(context, action, e))
                          .toList())),
                  SliverToBoxAdapter(child: SizedBox(height: 18.sp)),
                  SliverToBoxAdapter(
                      child: Text(
                    message('message_sent_friend_requests_size')
                        .format([state.sentRequests.length]),
                    style: TextStyle(
                      color: context.theme.colorScheme.secondary,
                      fontSize: 12.sp,
                    ),
                  )),
                  SliverToBoxAdapter(child: SizedBox(height: 14.sp)),
                  SliverList(
                      delegate: SliverChildListDelegate(sentRequests
                          .map((e) => sentRequest(context, action, e))
                          .toList())),
                ]),
              ),
            ),
            SizedBox(height: 8.sp),
          ],
        ));
  }

  Widget receivedRequest(BuildContext context, FriendRequestViewModel action, User friend) {
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
                    TouchableOpacity(
                        onTap: () => action.onTapAcceptFriendRequest(friend),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: BaseColor.green200),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.sp, horizontal: 7.sp),
                            child: Text(
                              message('generic_friend_accept'),
                              style: TextStyle(
                                color: BaseColor.warmGray500,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        )),
                    SizedBox(width: 5.sp),
                    TouchableOpacity(
                        onTap: () => action.onTapDenyFriendRequest(friend),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: BaseColor.red300),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.sp, horizontal: 7.sp),
                            child: Text(
                              message('generic_friend_deny'),
                              style: TextStyle(
                                color: BaseColor.warmGray500,
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

  Widget sentRequest(BuildContext context, FriendRequestViewModel action, User friend) {
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
                    TouchableOpacity(
                        onTap: () => action.onTapCancelFriendRequest(friend),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: BaseColor.red300),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.sp, horizontal: 7.sp),
                            child: Text(
                              message('generic_friend_cancel'),
                              style: TextStyle(
                                color: BaseColor.warmGray500,
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
