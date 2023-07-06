import 'package:magcloud_app/core/model/user.dart';

import 'diary.dart';

class DailyUser extends User {
  final Diary diary;
  DailyUser({required super.userId, required super.name, required super.nameTag, required super.isDiaryShared, required this.diary});
}
