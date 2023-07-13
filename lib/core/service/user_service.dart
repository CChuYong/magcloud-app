import 'package:magcloud_app/core/model/friend.dart';
import 'package:magcloud_app/core/model/user.dart';
import 'package:magcloud_app/core/service/diary_service.dart';
import 'package:magcloud_app/core/service/online_service.dart';

import '../../di.dart';
import '../api/open_api.dart';
import '../model/daily_user.dart';

class UserService {
  final OnlineService onlineService ;
  final OpenAPI openAPI;

  UserService({required this.onlineService, required this.openAPI});

  Future<List<Friend>> getFriends() async {
    if (onlineService.isOnlineMode()) {
      //TRY REFRESH ONLINE
      return (await openAPI.getFriends()).map((e) => e.toDomain()).toList();
    }

    return List.empty();
  }

  Future<List<User>> getFriendRequests() async {
    final requests = await openAPI.getFriendRequests();
    return requests.map((e) => e.toDomain()).toList();
  }

  Future<List<User>> getSentFriendRequests() async {
    final sentRequests = await openAPI.getSentFriendRequests();
    return sentRequests.map((e) => e.toDomain()).toList();
  }

  Future<User> getMe() async {
    final onlineMe = await openAPI.getMyProfile();
    //print(onlineMe.name);
    // final testMe = User(
    //     userId: 'sym', name: '송영민', nameTag: '송영민#1234');
    return onlineMe.toDomain();
  }

  Future<DailyUser> getDailyMe() async {
    final justMe = await getMe();
    final today = DateTime.now();
    final todayDiary = await inject<DiaryService>()
        .getDiary(today.year, today.month, today.day, false);
    return DailyUser(
        userId: justMe.userId,
        name: justMe.name,
        nameTag: justMe.nameTag,
        profileImageUrl: justMe.profileImageUrl,
        mood: todayDiary.mood);
  }

  Future<List<DailyUser>> getDailyFriends() async {
    if (!onlineService.isOnlineMode()) return List.empty();
    final dailyUsers = await openAPI.getDailyFriends();
    return dailyUsers.map((e) => e.toDomain()).toList();
  }
}
