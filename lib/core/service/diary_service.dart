import 'package:magcloud_app/core/api/dto/diary/diary_request.dart';
import 'package:magcloud_app/core/api/dto/diary/diary_update_request.dart';
import 'package:magcloud_app/core/api/open_api.dart';
import 'package:magcloud_app/core/model/diary.dart';
import 'package:magcloud_app/core/model/mood.dart';
import 'package:magcloud_app/core/repository/diary_repository.dart';
import 'package:magcloud_app/core/service/online_service.dart';
import 'package:magcloud_app/core/util/date_parser.dart';
import 'package:magcloud_app/core/util/hash_util.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/core/util/snack_bar_util.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/view/dialog/integrity_violation_dialog.dart';

class DiaryService {
  DiaryService(this.onlineService, this.diaryRepository);

  final OnlineService onlineService;
  final DiaryRepository diaryRepository;

  final OpenAPI openAPI = inject<OpenAPI>();

  Future<Diary> getDiary(int year, int month, int day, bool integrityCheck) async {
    final localDiary = await diaryRepository.findDiary(year, month, day);
    final today = DateTime(year, month, day);
    if(localDiary != null && onlineService.isOnlineMode()) {
      if(localDiary.diaryId == null){ //저장되지 않은 일기
        final savedDiary = await createDiaryOnServer(today, localDiary.mood, localDiary.content);
        if(savedDiary != null) {
          return await diaryRepository.saveDiary(savedDiary);
        }
      } else { //저장된 일기 유효성 검증
        final integrity = await openAPI.getDiaryIntegrity(localDiary.diaryId!);
        if(integrity.contentHash != localDiary.hash || integrity.emotion != localDiary.mood.toServerType()) {
          if(integrity.updatedAtTs > localDiary.updatedAt) {
            //머야 왜 서버가 더 최신임? ㄷㄷ
            if(!integrityCheck) return localDiary;
            final keepLocal = await keepLocalDialog(localDiary.updatedAt, integrity.updatedAtTs);
            if(keepLocal == null) throw Exception();
            if(!keepLocal) {
              final serverDiaryDto = await openAPI.getDiary(integrity.diaryId);
              final serverDiary = serverDiaryDto.toDomain();
              await diaryRepository.saveDiary(serverDiary);
              return serverDiary;
            }
          }
          //로컬 버전 서버와 동기화
          await openAPI.updateDiary(localDiary.diaryId!, DiaryUpdateRequest(emotion: localDiary.mood.toServerType(), content: localDiary.content));
        }
      }
    } else if(onlineService.isOnlineMode()) {
      try{
        final serverDiaryDto = await openAPI.getDiaryByDate(DateParser.formatDateTime(today));
        final serverDiary = serverDiaryDto.toDomain();
        await diaryRepository.saveDiary(serverDiary);
        return serverDiary;
      }catch(e){
        return Diary.create(ymd: today);
      }
    }
    return localDiary ?? Diary.create(ymd: today);
  }

  Future<Diary?> createDiaryOnServer(DateTime ymd, Mood mood, String content) async {
    try{
      final result = await openAPI.createDiary(DiaryRequest(date: DateParser.formatDateTime(ymd), emotion: mood.toServerType(), content: content));
      return result.toDomain();
    }catch(e){
      return null;
    }
  }

  Future<Diary> updateDiary(
      Diary currentDiary,
      Mood newMood,
      String content) async {
    if (content.isEmpty) return currentDiary;
    final hashedContent = HashUtil.hashContent(content);
    if (hashedContent == currentDiary.hash && newMood == currentDiary.mood) {
      return currentDiary;
    }
    final isOnline = onlineService.isOnlineMode();
    String? diaryId = currentDiary.diaryId;

    if (isOnline) {
      //SAVE TO SERVER;
      if(diaryId == null) {
        //FIRST SAVE
        final newSavedDiary = await createDiaryOnServer(currentDiary.ymd, newMood, content);
        print(newSavedDiary?.diaryId);
        diaryId = newSavedDiary?.diaryId;
      } else {
        //PATCH
        await openAPI.updateDiary(diaryId, DiaryUpdateRequest(emotion: newMood.toServerType(), content: content));
      }
    } else {
      //SAVE TO UNSAVED LOCAL REPO
      SnackBarUtil.infoSnackBar(message: message('message_diary_saved_offline'));
    }
    final newDiary = Diary(
      mood: newMood,
      content: content,
      ymd: currentDiary.ymd,
      hash: hashedContent,
      diaryId: diaryId,
      updatedAt: DateParser.nowAtMillis(),
    );
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
