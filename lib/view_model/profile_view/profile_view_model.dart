import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:magcloud_app/core/api/dto/friend/friend_accept_request.dart';
import 'package:magcloud_app/core/api/dto/profile_image_update_request.dart';
import 'package:magcloud_app/core/api/dto/user_nickname_request.dart';
import 'package:magcloud_app/core/api/open_api.dart';
import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/core/service/auth_service.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/core/util/image_picker.dart';
import 'package:magcloud_app/core/util/snack_bar_util.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/global_routes.dart';
import 'package:magcloud_app/view/page/profile_view.dart';
import 'package:magcloud_app/view_model/profile_view/profile_view_state.dart';

import '../../core/api/dto/diary/diary_comment_response.dart';
import '../../core/api/dto/friend/friend_request.dart';
import '../../core/model/feed_element.dart';
import '../../core/model/user.dart';
import '../../core/service/online_service.dart';
import '../../view/dialog/comment_list_dialog.dart';
import '../../view/dialog/user_nickname_dialog.dart';

class ProfileViewModel
    extends BaseViewModel<ProfileView, ProfileViewModel, ProfileViewState> {
  ProfileViewModel({required User user}) : super(ProfileViewState(user: user));

  final OpenAPI openAPI = inject<OpenAPI>();

  @override
  Future<void> initState() async {
    state.user =
        (await inject<OpenAPI>().getUserProfile(state.user.userId)).toDomain();
    await loadForward();
  }

  Future<void> reloadPage() async {
    await setStateAsync(() async {
      await initState();
    });
  }

  Future<void> loadForward() async {
    if (state.feeds.isEmpty) {
      final feeds =
          await inject<OpenAPI>().getFriendFeed(10, state.user.userId);
      state.feeds.addAll(feeds.map((e) => e.toDomain()));
    } else {
      final oldestEntry = state.feeds.last;
      final feeds = await inject<OpenAPI>()
          .getFriendFeedWithId(10, state.user.userId, oldestEntry.diaryId);
      state.feeds.addAll(feeds.map((e) => e.toDomain()));
    }
  }

  void copyTags(String tag) async {
    await Clipboard.setData(ClipboardData(text: tag));
    SnackBarUtil.infoSnackBar(
        message: message('message_tag_copied_to_clipboard'));
  }

  void changeNickname() async {
    final newName = await userNicknameDialog();
    if(newName.isEmpty) {
      SnackBarUtil.infoSnackBar(message: message('message_nickname_should_not_empty'));
      return;
    }
    final authService = inject<AuthService>();
    if(newName == authService.initialUser?.name){
      SnackBarUtil.infoSnackBar(message: message('message_nickname_should_not_same'));
      return;
    }
    final newUser = await inject<OpenAPI>().updateNickname(UserNickNameRequest(name: newName));
    authService.initialUser = newUser.toDomain();
    setState(() {
      state.user = newUser.toDomain();
      SnackBarUtil.infoSnackBar(message: message('message_nickname_changed'));
    });
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
      if (image == null) return;
      final imageRequest = await openAPI.getImageRequest();
      await inject<Dio>().request(imageRequest.uploadUrl,
          data: image.bytes,
          options: Options(
              method: 'PUT', headers: {'Content-Type': image.mimeType}));

      await openAPI.updateProfileImage(
          ProfileImageUpdateRequest(profileImageUrl: imageRequest.downloadUrl));
      SnackBarUtil.infoSnackBar(message: message('message_upload_succeed'));
      await setStateAsync(() async {
        state.user = (await openAPI.getMyProfile()).toDomain();
      });
    });
  }

  Future<void> requestFriend(User user) async {
    await asyncLoading(() async {
      final result = await inject<OpenAPI>()
          .requestFriend(FriendRequest(tag: user.nameTag));
      await GlobalRoute.back();
      SnackBarUtil.infoSnackBar(message: result.message);
    });
  }

  Future<void> deleteFriend(User user) async {
    await asyncLoading(() async {
      final result = await inject<OpenAPI>()
          .breakFriend(FriendAcceptRequest(userId: user.userId));
      SnackBarUtil.infoSnackBar(message: result.message);
    });
  }

  Future<void> onTapCommentBox(String diaryId) async {
    List<DiaryCommentResponse> comments = List.empty();
    await asyncLoading(() async {
      comments = await openAPI.getDiaryComments(diaryId);
    });
    await openCommentListDialog(diaryId, comments);

  }

  bool isMe(String userId) => inject<AuthService>().initialUser?.userId == userId;

  void onTapProfileImage(String userId) async {
    final user = await inject<OpenAPI>().getUserProfile(userId);
    route() => ProfileView(user.toDomain(), isMe(userId), true);
    GlobalRoute.rightToLeftRouteToDynamic(route);
  }

  void onTapLike(FeedElement element) async {
    await setStateAsync(() async {
      final result = await openAPI.likeDiary(element.diaryId);
      state.feeds.remove(element);
      state.feeds.add(result.toDomain());
      SnackBarUtil.infoSnackBar(message: message('message_liked_diary'));
    });
  }

  void onTapUnlike(FeedElement element) async {
    await setStateAsync(() async {
      final result = await openAPI.unlikeDiary(element.diaryId);
      state.feeds.remove(element);
      state.feeds.add(result.toDomain());
      SnackBarUtil.infoSnackBar(message: message('message_unliked_diary'));
    });
  }
}
