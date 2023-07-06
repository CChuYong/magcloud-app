import '../../core/model/user.dart';

class FriendViewState {
  String filterWord = "";
  final List<User> friends = List.empty(growable: true);

  Iterable<User> getFilteredFriends() => friends.where((element) => element.name.contains(filterWord));
}
