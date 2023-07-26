import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/core/model/feed_element.dart';
import 'package:magcloud_app/core/util/date_parser.dart';
import 'package:magcloud_app/core/util/extension.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/view/component/feed_element.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';

import '../../core/util/font.dart';
import '../../view_model/feed_view/feed_view_model.dart';
import '../../view_model/feed_view/feed_view_state.dart';
import '../designsystem/base_color.dart';
import '../dialog/image_preview_dialog.dart';
import '../navigator_view.dart';

class FeedView extends BaseView<FeedView, FeedViewModel, FeedViewState> {
  final NavigatorViewState navigator;

  FeedView(this.navigator, {super.key});

  @override
  bool isAutoRemove() => false;

  @override
  FeedViewModel initViewModel() => FeedViewModel(navigator);

  @override
  Color navigationBarColor() => BaseColor.warmGray100;

  @override
  Widget render(
      BuildContext context, FeedViewModel action, FeedViewState state) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.sp),
          titleBar(context, action),
          SizedBox(height: 3.sp),
          state.feeds.isEmpty
              ? Expanded(child: emptyFeedBox(context, height - 160.sp))
              : Expanded(child: feedBox(action, context))
        ],
      ),
    );
  }

  Widget titleBar(BuildContext context, FeedViewModel action) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              message('magcloud'),
              style: TextStyle(
                  color: context.theme.colorScheme.primary,
                  fontSize: 22.sp,
                  fontFamily: 'GmarketSans'),
            ),
            TouchableOpacity(
                onTap: action.navigateToWritePage,
                child: Container(
                  width: 31.sp,
                  height: 33.sp,
                  child: Icon(Icons.edit_calendar,
                      size: 22.sp, color: context.theme.colorScheme.secondary),
                  //  color: BaseColor.blue300,
                ))
          ],
        ));
  }

  Widget feedBox(FeedViewModel action, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            onRefresh: action.refreshFullPage,
            child: CustomScrollView(
                controller: action.scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                reverse: false,
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate(action.state.feeds
                          .map((e) => FeedElementView(e, width,
                            onTapComment: (elem) => action.onTapCommentBox(e.diaryId),
                          onTapProfileImage: (elem) => action.onTapProfileImage(elem.userId),
                          onTapLike: (elem) => action.onTapLike(elem),
                          onTapUnlike: (elem) => action.onTapUnlike(elem),
                      ))
                          .toList())),
                  SliverToBoxAdapter(child: SizedBox(height: 8.sp)),
                ]),
          ),
        ),
        SizedBox(height: 8.sp),
      ],
    );
  }

  Widget emptyFeedBox(BuildContext context, double height) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: action.refreshFullPage,
      child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          reverse: false,
          slivers: [
            SliverToBoxAdapter(
                child: Container(
                    height: height,
                    // width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_outlined,
                            size: 40.sp, color: context.theme.colorScheme.secondary),
                        Text(
                          message('message_feed_is_empty'),
                          style: TextStyle(
                              color: context.theme.colorScheme.primary, fontSize: 16.sp),
                        ),
                        Text(
                          message('message_add_your_friend_to_feed'),
                          style: TextStyle(
                              color: context.theme.colorScheme.secondary, fontSize: 14.sp),
                        ),
                      ],
                    )))
          ]),
    );
  }

}
