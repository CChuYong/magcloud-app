import 'package:injectable/injectable.dart';
import 'package:magcloud_app/core/model/diary.dart';
import 'package:magcloud_app/core/model/mood.dart';

@injectable
class DiaryService {
  Future<Diary> getDiary(int year, int month, int day) async {
    return Diary(mood: Mood.sad, content: '엄준식이었어요..');
  }

  Future<Map<int, Mood>> getMonthlyMood(int year) async {
    return {
      1: Mood.sad,
      2: Mood.happy,
      3: Mood.angry,
      4: Mood.sad,
      5: Mood.sad,
      6: Mood.angry,
      7: Mood.sad,
      8: Mood.sad,
      9: Mood.amazed,
      10: Mood.sad,
      11: Mood.sad,
      12: Mood.sad,
    };
  }


  Future<Map<int, Mood>> getDailyMood(int year, int month) async {
    return {
      1: Mood.sad,
      2: Mood.happy,
      3: Mood.angry,
      4: Mood.sad,
      5: Mood.sad,
      6: Mood.angry,
      7: Mood.sad,
      8: Mood.sad,
      9: Mood.amazed,
      10: Mood.sad,
      11: Mood.sad,
      12: Mood.sad,
    };
  }
}
