import 'package:injectable/injectable.dart';
import 'package:magcloud_app/core/model/diary.dart';
import 'package:magcloud_app/core/model/mood.dart';
import 'package:magcloud_app/core/model/user.dart';
import 'package:magcloud_app/core/service/online_service.dart';

import '../../di.dart';
import '../model/daily_user.dart';

@singleton
class UserService {
  final OnlineService onlineService = inject<OnlineService>();
  Future<List<User>> getFriends() async {
    final temp = List<User>.empty(growable: true);
    temp.add(User(name: '엄준식', nameTag: '엄준식#1234', isDiaryShared: false));
    temp.add(User(name: '송영민', nameTag: '송영민#1234', isDiaryShared: true));
    temp.add(User(name: '공지훈', nameTag: '공지훈#1234', isDiaryShared: false));

    if(onlineService.isOnlineMode()) {
      //TRY REFRESH ONLINE
    }

    return temp;
  }

  Future<User> getMe() async{
    return User(name: '송영민', nameTag: '송영민#1234', isDiaryShared: true);
  }

  Future<List<DailyUser>> getDailyFriends() async {
    final temp = List<DailyUser>.empty(growable: true);
    temp.add(DailyUser(name: '엄준식', nameTag: '엄준식#1234', isDiaryShared: false, diary: Diary(mood: Mood.sad, content: '', ymd: DateTime.now(), hash: 'asdf')));
    temp.add(DailyUser(name: '송영민', nameTag: '송영민#1234', isDiaryShared: true, diary: Diary(mood: Mood.happy, content: '', ymd: DateTime.now(), hash: 'asdf')));
    temp.add(DailyUser(name: '공지훈', nameTag: '공지훈#1234', isDiaryShared: false, diary: Diary(mood: Mood.angry, content: '', ymd: DateTime.now(), hash: 'asdf')));

    return temp;
  }
}
