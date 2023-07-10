import 'package:flutter/cupertino.dart';
import 'package:magcloud_app/core/api/dto/friend/friend_accept_request.dart';
import 'package:magcloud_app/core/api/dto/friend/friend_request.dart';
import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/core/service/user_service.dart';
import 'package:magcloud_app/core/util/snack_bar_util.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/view/page/friend_request_view.dart';

import '../../core/api/open_api.dart';
import '../../core/model/user.dart';
import '../../global_routes.dart';
import '../../view/dialog/friend_request_dialog.dart';
import '../../view/page/profile_view.dart';
import 'friend_request_view_state.dart';

class FriendRequestViewModel extends BaseViewModel<FriendRequestView, FriendRequestViewModel, FriendRequestViewState> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final OpenAPI openApi = inject<OpenAPI>();
  FriendRequestViewModel() : super(FriendRequestViewState()) {
    searchController.addListener(applySearch);
  }

  final userService = inject<UserService>();

  void applySearch() {
    setState(() {
      state.filterWord = searchController.text;
    });
  }

  @override
  Future<void> initState() async {
    state.sentRequests = await userService.getSentFriendRequests();
    state.requests = await userService.getFriendRequests();
  }

  Future<void> reloadRequests() async {
    setStateAsync(() async {
      await initState();
    });
  }

  void onTapFriend(User user) {
    route() => ProfileView(user, false);
    GlobalRoute.rightToLeftRouteToDynamic(route);
  }

  void onTapFriendAddButton() async {
    final tag = await friendRequestDialog();
    if(tag.isNotEmpty) {
      final result = await openApi.requestFriend(FriendRequest(tag: tag));
      SnackBarUtil.infoSnackBar(message: result.message);
      await reloadRequests();
    }
  }

  void onTapAcceptFriendRequest(User user) async {
    final result = await openApi.acceptFriendRequest(FriendAcceptRequest(userId: user.userId));
    SnackBarUtil.infoSnackBar(message: result.message);

    setStateAsync(() async {
      state.requests = await userService.getFriendRequests();
    });
  }

  void onTapDenyFriendRequest(User user) async {
    final result = await openApi.denyFriendRequest(FriendAcceptRequest(userId: user.userId));
    SnackBarUtil.infoSnackBar(message: result.message);
    setStateAsync(() async {
      state.requests = await userService.getFriendRequests();
    });
  }

  void onTapCancelFriendRequest(User user) async {
    final result = await openApi.cancelFriendRequest(FriendAcceptRequest(userId: user.userId));
    SnackBarUtil.infoSnackBar(message: result.message);
    setStateAsync(() async {
      state.sentRequests = await userService.getSentFriendRequests();
    });
  }
}
