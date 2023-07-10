import 'package:magcloud_app/core/model/diary.dart';
import 'package:magcloud_app/core/model/friend.dart';
import 'package:magcloud_app/core/model/mood.dart';
import 'package:magcloud_app/core/model/user.dart';
import 'package:magcloud_app/core/service/diary_service.dart';
import 'package:magcloud_app/core/service/online_service.dart';

import '../../di.dart';
import '../api/open_api.dart';
import '../model/daily_user.dart';

class UserService {
  final OnlineService onlineService = inject<OnlineService>();
  final OpenAPI openAPI = inject<OpenAPI>();

  Future<List<Friend>> getFriends() async {
    final temp = List<Friend>.empty(growable: true);
    temp.add(Friend(
        userId: 'ujs', name: '엄준식', nameTag: '엄준식#1234', isDiaryShared: false, profileImageUrl: "https://bsc-assets-public.s3.ap-northeast-2.amazonaws.com/default_profile.jpeg",));
    temp.add(Friend(
        userId: 'gjh', name: '공지훈', nameTag: '공지훈#1234', isDiaryShared: true, profileImageUrl: "https://bsc-assets-public.s3.ap-northeast-2.amazonaws.com/default_profile.jpeg",));

    if (onlineService.isOnlineMode()) {
      //TRY REFRESH ONLINE
      return (await openAPI.getFriends()).map((e) => e.toDomain()).toList();
    }

    return temp;
  }

  Future<List<User>> getFriendRequests() async {
    final requests = await openAPI.getFriendRequests();
    return requests.map((e) => e.toDomain()).toList();
  }

  Future<List<User>> getSentFriendRequests() async {
    // final temp = List<Friend>.empty(growable: true);
    // temp.add(Friend(
    //   userId: 'ujs', name: '엄준식', nameTag: '엄준식#1234', isDiaryShared: false, profileImageUrl: "https://bsc-assets-public.s3.ap-northeast-2.amazonaws.com/default_profile.jpeg",));
    // temp.add(Friend(
    //   userId: 'gjh', name: '공지훈', nameTag: '공지훈#1234', isDiaryShared: true, profileImageUrl: "https://bsc-assets-public.s3.ap-northeast-2.amazonaws.com/default_profile.jpeg",));
    // return temp;
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
        mood: todayDiary.mood
    );
  }

  Future<List<DailyUser>> getDailyFriends() async {
    if (!onlineService.isOnlineMode()) return List.empty();
    final dailyUsers = await openAPI.getDailyFriends();
    return dailyUsers.map((e) => e.toDomain()).toList();
  }
}
