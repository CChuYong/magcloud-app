import 'package:flutter/cupertino.dart';
import 'package:magcloud_app/core/api/dto/friend/friend_accept_request.dart';
import 'package:magcloud_app/core/api/open_api.dart';
import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/core/framework/state_store.dart';
import 'package:magcloud_app/core/model/user.dart';
import 'package:magcloud_app/core/service/online_service.dart';
import 'package:magcloud_app/core/service/user_service.dart';
import 'package:magcloud_app/core/util/extension.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/core/util/snack_bar_util.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/global_routes.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';
import 'package:magcloud_app/view/dialog/confirm_dialog.dart';
import 'package:magcloud_app/view/page/friend_view.dart';
import 'package:magcloud_app/view/page/profile_view.dart';

import 'friend_view_state.dart';

class FriendViewModel
    extends BaseViewModel<FriendView, FriendViewModel, FriendViewState> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  FriendViewModel() : super(FriendViewState()) {
    searchController.addListener(applySearch);
  }

  final userService = inject<UserService>();
  final openAPI = inject<OpenAPI>();
  final onlineService = inject<OnlineService>();

  @override
  Future<void> initState() async {
    if(onlineService.isOnlineMode()) {
      await reloadFriends();
      state.requestCount = (await openAPI.getFriendRequestsCount()).count;
      StateStore.setInt("friendRequestCount", state.requestCount);
    }
  }

  @override
  void onReloaded() {
    setStateAsync(() async {
      await initState();
    });
  }

  @override
  void dispose() {}

  void applySearch() {
    setState(() {
      state.filterWord = searchController.text;
    });
  }

  Future<void> reloadFriends() async {
    setStateAsync(() async {
      state.friends = await userService.getFriends();
    });
  }

  void onTapAddFriend() async {
    if(!inject<OnlineService>().isOnlineMode()) {
      SnackBarUtil.errorSnackBar(message: message('message_offline_cannot_use_that'));
      return;
    }
    await GlobalRoute.rightToLeftRouteTo('/friends/requests');
    onReloaded();
  }

  void onTapShareDiary(User user) async {
    asyncLoading(() async {
      final deleteResult = await openAPI.shareDiary(FriendAcceptRequest(userId: user.userId));
      SnackBarUtil.infoSnackBar(message: deleteResult.message);
      await reloadFriends();
    });
  }

  void onTapUnShareDiary(User user) async {
    asyncLoading(() async {
      final deleteResult = await openAPI.unShareDiary(FriendAcceptRequest(userId: user.userId));
      SnackBarUtil.infoSnackBar(message: deleteResult.message);
      await reloadFriends();
    });
  }

  void onTapFriend(User user) {
    route() => ProfileView(user, false);
    GlobalRoute.rightToLeftRouteToDynamic(route);
  }

  void onTapDeleteFriend(User user) async {
    final result = await confirmDialog(message('generic_break_friend'), message('message_friend_delete_confirm').format([user.name]), confirmText: message('generic_delete'), confirmColor: BaseColor.red300);
    if(result) {
      asyncLoading(() async {
        final deleteResult = await openAPI.breakFriend(FriendAcceptRequest(userId: user.userId));
        SnackBarUtil.infoSnackBar(message: deleteResult.message);
        await reloadFriends();
      });
    }
  }
}
