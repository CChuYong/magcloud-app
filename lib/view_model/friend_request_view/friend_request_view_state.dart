import '../../core/model/user.dart';

class FriendRequestViewState {
  String filterWord = "";
  List<User> requests = List.empty();
  List<User> sentRequests = List.empty();

  Iterable<User> getFilteredRequests() =>
      requests.where((element) => element.name.contains(filterWord));

  Iterable<User> getFilteredSentRequests() =>
      sentRequests.where((element) => element.name.contains(filterWord));
}
