import 'package:injectable/injectable.dart';
import 'package:magcloud_app/core/model/diary.dart';
import 'package:magcloud_app/core/model/mood.dart';
import 'package:magcloud_app/core/repository/diary_repository.dart';
import 'package:magcloud_app/core/util/hash_util.dart';
import 'package:magcloud_app/main.dart';

@injectable
class DiaryService {
  final DiaryRepository diaryRepository = inject<DiaryRepository>();
  Future<Diary> getDiary(int year, int month, int day) async {
    final localDiary = await diaryRepository.findDiary(year, month, day);
    return localDiary ?? Diary(mood: Mood.neutral, content: '', ymd: DateTime(year, month, day), hash: HashUtil.emptyHash());
  }

  Future<Diary> updateDiary(Diary currentDiary, String content) async {
    final hashedContent = HashUtil.hashContent(content);
    if(hashedContent == currentDiary.hash) return currentDiary;
    final newDiary = Diary(
        mood: currentDiary.mood,
        content: content,
        ymd: currentDiary.ymd,
        hash: hashedContent
    );
    await diaryRepository.saveDiary(newDiary);
    return newDiary;
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
      5: Mood.neutral,
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
