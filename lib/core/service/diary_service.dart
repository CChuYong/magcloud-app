import 'package:injectable/injectable.dart';
import 'package:magcloud_app/core/model/diary.dart';
import 'package:magcloud_app/core/model/mood.dart';
import 'package:magcloud_app/core/repository/diary_repository.dart';
import 'package:magcloud_app/core/service/online_service.dart';
import 'package:magcloud_app/core/util/hash_util.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/core/util/snack_bar_util.dart';

@singleton
class DiaryService {
  DiaryService(this.onlineService, this.diaryRepository);

  final OnlineService onlineService;
  final DiaryRepository diaryRepository;

  Future<Diary> getDiary(int year, int month, int day) async {
    final localDiary = await diaryRepository.findDiary(year, month, day);
    return localDiary ??
        Diary(
            mood: Mood.neutral,
            content: '',
            ymd: DateTime(year, month, day),
            hash: HashUtil.emptyHash()
        );
  }

  Future<Diary> updateDiary(Diary currentDiary, String content) async {
    final hashedContent = HashUtil.hashContent(content);
    if (hashedContent == currentDiary.hash) return currentDiary;

    final isOnline = onlineService.isOnlineMode();
    if (isOnline) {
      //SAVE TO SERVER;
    } else {
      //SAVE TO UNSAVED LOCAL REPO
      SnackBarUtil.infoSnackBar(
          message: message('message_diary_saved_offline'));
    }
    final newDiary = Diary(
        mood: currentDiary.mood,
        content: content,
        ymd: currentDiary.ymd,
        hash: hashedContent);
    await diaryRepository.saveDiary(newDiary);
    return newDiary;
  }

  Future<Map<int, Mood>> getMonthlyMood(int year) async {
    final monthlyMood = await diaryRepository.findMonthlyMood(year);
    return monthlyMood;
  }

  Future<Map<int, Mood>> getDailyMood(int year, int month) async {
    final dailyMood = await diaryRepository.findDailyMood(year, month);
    return dailyMood;
  }
}
