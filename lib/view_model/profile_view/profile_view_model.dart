import 'package:flutter/services.dart';
import 'package:magcloud_app/core/api/dto/profile_image_update_request.dart';
import 'package:magcloud_app/core/api/open_api.dart';
import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/core/util/image_picker.dart';
import 'package:magcloud_app/core/util/snack_bar_util.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/view/page/profile_view.dart';
import 'package:magcloud_app/view_model/profile_view/profile_view_state.dart';
import 'package:dio/dio.dart';

import '../../core/api/dto/friend/friend_request.dart';
import '../../core/model/user.dart';
import '../../core/service/online_service.dart';

class ProfileViewModel
    extends BaseViewModel<ProfileView, ProfileViewModel, ProfileViewState> {
  ProfileViewModel({required User user}) : super(ProfileViewState(user: user));

  @override
  Future<void> initState() async {
    state.user = (await inject<OpenAPI>().getUserProfile(state.user.userId)).toDomain();
    await loadForward();
  }

  Future<void> loadForward() async {
    if(state.feeds.isEmpty) {
      final feeds = await inject<OpenAPI>().getFriendFeed(10, state.user.userId);
      state.feeds.addAll(feeds.map((e) => e.toDomain()));
    } else {
      final oldestEntry = state.feeds.last;
      final feeds = await inject<OpenAPI>().getFriendFeedWithId(10, state.user.userId, oldestEntry.diaryId);
      state.feeds.addAll(feeds.map((e) => e.toDomain()));
    }
  }

  void copyTags(String tag) async {
    await Clipboard.setData(ClipboardData(text: tag));
    SnackBarUtil.infoSnackBar(message: message('message_tag_copied_to_clipboard'));
  }

  Future<void> updateProfileImage() async {
    if (!inject<OnlineService>().isOnlineMode()) {
      SnackBarUtil.errorSnackBar(
          message: message('message_offline_cannot_use_that'));
      return;
    }
    final image = await ImagePickerUtil.pickImage();
    await asyncLoading(() async {
      final openAPI = inject<OpenAPI>();
      if(image == null) return;
      final imageRequest = await openAPI.getImageRequest();
      await inject<Dio>().request(imageRequest.uploadUrl,
          data: image.bytes,
          options: Options(method: 'PUT', headers: {'Content-Type': image.mimeType}));

      await openAPI
          .updateProfileImage(ProfileImageUpdateRequest(profileImageUrl: imageRequest.downloadUrl));
      SnackBarUtil.infoSnackBar(message: message('message_upload_succeed'));
      await setStateAsync(() async {
        state.user = (await openAPI.getMyProfile()).toDomain();
      });
    });
  }

  Future<void> requestFriend(User user) async {
    await asyncLoading(() async {
      final result = await inject<OpenAPI>().requestFriend(FriendRequest(tag: user.nameTag));
      SnackBarUtil.infoSnackBar(message: result.message);
    });
  }
}
