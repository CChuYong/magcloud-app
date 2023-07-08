import 'package:flutter/services.dart';
import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/core/util/image_picker.dart';
import 'package:magcloud_app/core/util/snack_bar_util.dart';
import 'package:magcloud_app/view/page/profile_view.dart';
import 'package:magcloud_app/view_model/profile_view/profile_view_state.dart';

class ProfileViewModel
    extends BaseViewModel<ProfileView, ProfileViewModel, ProfileViewState> {
  ProfileViewModel() : super(ProfileViewState());

  @override
  Future<void> initState() async {}

  void copyTags(String tag) async {
    await Clipboard.setData(ClipboardData(text: tag));
    SnackBarUtil.infoSnackBar(message: '태그가 클립보드에 복사되었어요!');
  }

  Future<void> updateProfileImage() async {
    final image = await ImagePickerUtil.pickImage();
  }
}
