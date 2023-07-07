import 'package:injectable/injectable.dart';
import 'package:magcloud_app/core/model/diary.dart';
import 'package:magcloud_app/core/model/mood.dart';
import 'package:magcloud_app/core/model/user.dart';
import 'package:magcloud_app/core/service/diary_service.dart';
import 'package:magcloud_app/core/service/online_service.dart';

import '../../di.dart';
import '../model/daily_user.dart';

@singleton
class UserService {
  final OnlineService onlineService = inject<OnlineService>();

  Future<List<User>> getFriends() async {
    final temp = List<User>.empty(growable: true);
    temp.add(User(
        userId: 'ujs', name: '엄준식', nameTag: '엄준식#1234', isDiaryShared: false));
    temp.add(User(
        userId: 'gjh', name: '공지훈', nameTag: '공지훈#1234', isDiaryShared: true));

    if (onlineService.isOnlineMode()) {
      //TRY REFRESH ONLINE
    }

    return temp;
  }

  Future<User> getMe() async {
    return User(
        userId: 'sym', name: '송영민', nameTag: '송영민#1234', isDiaryShared: true);
  }

  Future<DailyUser> getDailyMe() async {
    final justMe = await getMe();
    final today = DateTime.now();
    final todayDiary = await inject<DiaryService>()
        .getDiary(today.year, today.month, today.day);
    return DailyUser(
        userId: justMe.userId,
        name: justMe.name,
        nameTag: justMe.nameTag,
        isDiaryShared: true,
        diary: todayDiary);
  }

  Future<List<DailyUser>> getDailyFriends() async {
    if (!onlineService.isOnlineMode()) return List.empty();
    final temp = List<DailyUser>.empty(growable: true);
    temp.add(DailyUser(
        userId: 'ujs',
        name: '엄준식',
        nameTag: '엄준식#1234',
        isDiaryShared: false,
        diary: Diary(
            mood: Mood.sad, content: '', ymd: DateTime.now(), hash: 'asdf')));
    temp.add(DailyUser(
        userId: 'gjh',
        name: '공지훈',
        nameTag: '공지훈#1234',
        isDiaryShared: true,
        diary: Diary(
            mood: Mood.angry, content: '', ymd: DateTime.now(), hash: 'asdf')));

    return temp;
  }
}
