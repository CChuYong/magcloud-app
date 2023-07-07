import 'package:flutter/cupertino.dart';
import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/core/service/user_service.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/view/page/friend_view.dart';

import 'friend_view_state.dart';

class FriendViewModel
    extends BaseViewModel<FriendView, FriendViewModel, FriendViewState> {
  final TextEditingController searchController = TextEditingController();

  FriendViewModel() : super(FriendViewState()) {
    searchController.addListener(applySearch);
  }

  final userService = inject<UserService>();

  @override
  Future<void> initState() async {
    await reloadFriends();
  }

  @override
  void dispose() {

  }

  void applySearch() {
    setState(() {
      state.filterWord = searchController.text;
    });
  }

  Future<void> reloadFriends() async {
    state.friends = await userService.getFriends();
  }
}
