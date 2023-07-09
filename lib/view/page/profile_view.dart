import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/core/model/user.dart';
import 'package:magcloud_app/core/util/extension.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/view/component/base_settings_layout.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';
import 'package:magcloud_app/view/dialog/image_preview_dialog.dart';

import '../../view_model/profile_view/profile_view_model.dart';
import '../../view_model/profile_view/profile_view_state.dart';

class ProfileView
    extends BaseView<ProfileView, ProfileViewModel, ProfileViewState> {
  final User user;
  final bool isMe;

  ProfileView(this.user, this.isMe, {super.key});

  @override
  ProfileViewModel initViewModel() => ProfileViewModel(user: user);

  @override
  Widget render(
      BuildContext context, ProfileViewModel action, ProfileViewState state) {
    return BaseSettingLayout(
        title: isMe
            ? message('my_profile')
            : message('friend_profile').format([state.user.name]),
        child: SizedBox(
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
                        color: BaseColor.warmGray700, fontSize: 24.sp)),
                Text(state.user.nameTag,
                    style: TextStyle(
                        color: BaseColor.warmGray500, fontSize: 18.sp)),
                SizedBox(height: 10.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isMe
                        ? button(message('generic_change_profile_image'), action.updateProfileImage)
                        : button(message('generic_request_friend'), () {}),
                    SizedBox(width: 10.sp),
                    button(message('generic_copy_tags'),
                        () => action.copyTags(state.user.nameTag)),
                  ],
                )
              ],
            )));
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
}
