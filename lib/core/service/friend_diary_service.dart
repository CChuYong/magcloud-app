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

  Future<Diary?> getDiary(String userId, int year, int month, int day) async {
    final ymd = DateParser.formatYmd(year, month, day);
    try{
      final diary = await openAPI.getFriendDiaryByDate(userId, ymd);
      return diary.toDomain();
    }catch(e) {
      print("Returns null");
      return null;
    }
  }

  Future<Map<int, Mood>> getMonthlyMood(int year) async {
    throw Exception();
  }

  Future<Map<int, Mood>> getDailyMood(int year, int month) async {
    throw Exception();
  }
}
