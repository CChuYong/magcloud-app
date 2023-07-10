import 'package:magcloud_app/core/framework/state_store.dart';

import '../../core/model/friend.dart';

class FriendViewState {
  String filterWord = "";
  List<Friend> friends = List.empty(growable: false);
  int requestCount = StateStore.getInt("friendRequestCount") ?? 0;

  Iterable<Friend> getFilteredFriends() =>
      friends.where((element) => element.name.contains(filterWord));
}
