import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/core/model/feed_element.dart';
import 'package:magcloud_app/core/util/date_parser.dart';
import 'package:magcloud_app/core/util/extension.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';

import '../../core/util/font.dart';
import '../../view_model/feed_view/feed_view_model.dart';
import '../../view_model/feed_view/feed_view_state.dart';
import '../designsystem/base_color.dart';
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
          titleBar(action),
          SizedBox(height: 3.sp),
          // Divider(),
          state.feeds.isEmpty
              ? Expanded(child: emptyFeedBox(height - 160.sp))
              : Expanded(child: feedBox(action))
        ],
      ),
    );
  }

  Widget titleBar(FeedViewModel action) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              message('magcloud'),
              style: TextStyle(
                  color: BaseColor.warmGray700,
                  fontSize: 22.sp,
                  fontFamily: 'GmarketSans'),
            ),
            TouchableOpacity(
                onTap: action.navigateToWritePage,
                child: Container(
                  width: 31.sp,
                  height: 33.sp,
                  child: Icon(Icons.edit_calendar,
                      size: 22.sp, color: BaseColor.warmGray600),
                  //  color: BaseColor.blue300,
                ))
          ],
        ));
  }

  Widget feedBox(FeedViewModel action) {
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
                          .map((e) => feed(action, e))
                          .toList())),
                  SliverToBoxAdapter(child: SizedBox(height: 8.sp)),
                ]),
          ),
        ),
        SizedBox(height: 8.sp),
      ],
    );
  }

  Widget emptyFeedBox(double height) {
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
                            size: 40.sp, color: BaseColor.warmGray600),
                        Text(
                          message('message_feed_is_empty'),
                          style: TextStyle(
                              color: BaseColor.warmGray600, fontSize: 16.sp),
                        ),
                        Text(
                          message('message_add_your_friend_to_feed'),
                          style: TextStyle(
                              color: BaseColor.warmGray600, fontSize: 14.sp),
                        ),
                      ],
                    )))
          ]),
    );
  }

  Widget friendProfileIcon(Color color, String? url) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 36.sp,
          height: 36.sp,
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
          width: 44.sp,
          height: 44.sp,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3.0),
          ),
        )
      ],
    );
  }

  Widget feed(FeedViewModel action, FeedElement element) {
    final divider = Divider(color: BaseColor.warmGray200, thickness: 1.sp);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        divider,
        SizedBox(height: 8.sp),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TouchableOpacity(
                        onTap: () => action.onTapProfileImage(element.userId),
                        child: friendProfileIcon(
                            element.mood.moodColor, element.profileImageUrl)),
                    SizedBox(width: 8.sp),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          element.userName,
                          style: TextStyle(
                              color: BaseColor.warmGray800,
                              fontSize: 14.sp,
                              height: 1.3,
                              fontFamily: 'Pretendard'),
                        ),
                        Text(
                          message('generic_created_before').format(
                              [DateParser.gapBetweenNow(element.createdAt)]),
                          style: TextStyle(
                              color: BaseColor.warmGray600,
                              fontSize: 12.sp,
                              height: 1.3,
                              fontFamily: 'Pretendard'),
                        ),
                      ],
                    )
                  ],
                ),
                TouchableOpacity(
                    onTap: () => action.onTapProfileImage(element.userId),
                    child: Container(
                      width: 24.sp,
                      height: 33.sp,
                      //color: Colors.blueAccent,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Icon(Icons.calendar_today_outlined, size: 18.sp, color: BaseColor.warmGray400),
                            Icon(Icons.arrow_forward_outlined,
                                size: 24.sp, color: BaseColor.warmGray400),
                          ]),
                      //  color: BaseColor.blue300,
                    ))
              ],
            )),
        // divider,
        SizedBox(height: 8.sp),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 17.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateParser.formatLocaleYmd(element.ymd),
                style: TextStyle(
                    color: BaseColor.warmGray700,
                    fontSize: diaryFontSize * 1.2,
                    fontFamily: diaryFont),
              ),
              Text(
                element.content,
                style: TextStyle(
                    color: BaseColor.warmGray700,
                    fontSize: diaryFontSize,
                    fontFamily: diaryFont),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15.sp,
        ),
      ],
    );
  }
}
