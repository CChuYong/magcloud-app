import 'package:magcloud_app/core/model/diary.dart';
import 'package:magcloud_app/core/model/mood.dart';
import 'package:magcloud_app/core/service/online_service.dart';

import '../../di.dart';
import '../api/open_api.dart';
import '../util/date_parser.dart';

class FriendDiaryService {
  FriendDiaryService(this.onlineService);

  final OnlineService onlineService;
  final OpenAPI openAPI = inject<OpenAPI>();

  Future<Diary?> getDiary(String userId, DateTime date) async {
    final ymd = DateParser.formatDateTime(date);
    try {
      final diary = await openAPI.getFriendDiaryByDate(userId, ymd);
      return diary.toDomain();
    } catch (e) {
      print("Returns null");
      return null;
    }
  }

  Future<Map<int, Mood>> getMonthlyMood(String userId, DateTime date) async {
    return (await openAPI.getFriendYearlyStatistics(userId, date.year))
        .map((key, value) => MapEntry(int.parse(key), Mood.parseMood(value)));
  }

  Future<Map<int, Mood>> getDailyMood(String userId, DateTime date) async {
    return (await openAPI.getFriendMonthlyStatistics(
            userId, date.year, date.month))
        .map((key, value) => MapEntry(int.parse(key), Mood.parseMood(value)));
  }
}
