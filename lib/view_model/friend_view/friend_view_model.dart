import 'package:flutter/cupertino.dart';
import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/core/model/user.dart';
import 'package:magcloud_app/view/page/friend_view.dart';

import 'friend_view_state.dart';

class FriendViewModel
    extends BaseViewModel<FriendView, FriendViewModel, FriendViewState> {
  final TextEditingController searchController = TextEditingController();

  FriendViewModel() : super(FriendViewState()) {
    searchController.addListener(applySearch);
  }

  @override
  Future<void> initState() async {
    state.friends.add(User(name: '엄준식', nameTag: '엄준식#1234', isDiaryShared: false));
    state.friends.add(User(name: '송영민', nameTag: '송영민#1234', isDiaryShared: true));
    state.friends.add(User(name: '공지훈', nameTag: '공지훈#1234', isDiaryShared: false));
  }

  @override
  void dispose() {
    searchController.dispose();
  }

  void applySearch() {
    setState(() {
      state.filterWord = searchController.text;
    });
  }
}
