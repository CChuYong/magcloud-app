import '../../core/model/friend.dart';

class FriendViewState {
  String filterWord = "";
  List<Friend> friends = List.empty(growable: false);

  Iterable<Friend> getFilteredFriends() =>
      friends.where((element) => element.name.contains(filterWord));
}
