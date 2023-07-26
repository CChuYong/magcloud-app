import 'dart:collection';

import 'package:magcloud_app/core/model/user.dart';
import '../api/open_api.dart';

class TagResolver {
  final OpenAPI openAPI;

  TagResolver({required this.openAPI});

  HashMap<String, User> friendCache = HashMap();

  Future<void> loadFriends() async {
    final friendResponse = await openAPI.getFriends();
    for (final friend in friendResponse) {
      friendCache[friend.userId] = friend.toDomain();
    }
  }

  Future<User?> getByUserId(String userId) async {
    try{
      final userResponse = await openAPI.getUserProfile(userId);
      return userResponse.toDomain();
    } catch(e){
      return null;
    }
  }
}
