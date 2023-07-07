import '../../core/model/user.dart';

class FriendViewState {
  String filterWord = "";
  List<User> friends = List.empty(growable: false);

  Iterable<User> getFilteredFriends() =>
      friends.where((element) => element.name.contains(filterWord));
}
