import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/core/model/user.dart';
import 'package:magcloud_app/core/util/extension.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/view/component/base_settings_layout.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';
import 'package:magcloud_app/view/dialog/image_preview_dialog.dart';

import '../../core/model/feed_element.dart';
import '../../core/util/date_parser.dart';
import '../../core/util/font.dart';
import '../../view_model/feed_view/feed_view_model.dart';
import '../../view_model/profile_view/profile_view_model.dart';
import '../../view_model/profile_view/profile_view_state.dart';

class ProfileView
    extends BaseView<ProfileView, ProfileViewModel, ProfileViewState> {
  final User user;
  final bool isMe;
  final bool isFriend;

  ProfileView(this.user, this.isMe, this.isFriend, {super.key});

  @override
  ProfileViewModel initViewModel() => ProfileViewModel(user: user);

  @override
  Widget render(
      BuildContext context, ProfileViewModel action, ProfileViewState state) {
    return BaseSettingLayout(
        title: isMe
            ? message('my_profile')
            : message('friend_profile').format([state.user.name]),
        child: RefreshIndicator(
    triggerMode: RefreshIndicatorTriggerMode.onEdge,
    onRefresh: action.reloadPage,
    child: CustomScrollView(
          //  controller: action.scrollController,
            //physics: const AlwaysScrollableScrollPhysics(),
            reverse: false,
            slivers: [
              SliverToBoxAdapter(child:        SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 15.sp),
                      GestureDetector(
                        onTap: () {
                          imagePreviewDialog(state.user.profileImageUrl);
                        },
                        child: Container(
                          width: 84.sp,
                          height: 84.sp,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                CachedNetworkImageProvider(state.user.profileImageUrl),
                                fit: BoxFit.cover,
                              ),
                              color: BaseColor.defaultBackgroundColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: BaseColor.warmGray300, width: 0.5)),
                        ),
                      ),
                      SizedBox(height: 10.sp),
                      Text(state.user.name,
                          style: TextStyle(
                              color: BaseColor.warmGray700, fontSize: 20.sp)),
                      Text(state.user.nameTag,
                          style: TextStyle(
                              color: BaseColor.warmGray500, fontSize: 14.sp)),
                      SizedBox(height: 16.sp),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isMe
                              ? button(message('generic_change_profile_image'), action.updateProfileImage)
                              : (!isFriend ? button(message('generic_request_friend'), () => action.requestFriend(state.user)) :
                          button(message('generic_break_friend'), () => action.deleteFriend(state.user))),
                          SizedBox(width: 10.sp),
                          button(message('generic_copy_tags'),
                                  () => action.copyTags(state.user.nameTag)),
                        ],
                      ),
                      SizedBox(height: 10.sp),
                     // Padding(padding: EdgeInsets.symmetric(horizontal: 25.sp),child: Divider(color: BaseColor.warmGray200))
                    ],
                  ))),
              SliverList(
                  delegate: SliverChildListDelegate(action.state.feeds.map((e) => feed(action, e)).toList())),

            ])));
  }

  Widget button(String title, void Function() onTap) {
    return TouchableOpacity(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: BaseColor.warmGray100),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.sp, horizontal: 24.sp),
            child: Text(
              title,
              style: TextStyle(
                color: BaseColor.warmGray500,
                fontSize: 12.sp,
              ),
            ),
          ),
        ));
  }


  Widget feed(ProfileViewModel action, FeedElement element) {
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
                  friendProfileIcon(element.mood.moodColor, element.profileImageUrl),
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
                          message('generic_created_before').format([DateParser.gapBetweenNow(element.createdAt)]),
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
                  //  onTap: action.onTapAddFriend,
                    child: Container(
                      width: 24.sp,
                      height: 33.sp,
                      //color: Colors.blueAccent,
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
          height: 30.sp,
        ),
      ],
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
}
