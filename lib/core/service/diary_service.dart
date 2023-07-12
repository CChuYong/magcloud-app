import 'dart:collection';

import 'package:magcloud_app/core/api/dto/diary/diary_integrity_response.dart';
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
  final HashSet<String> syncedSet = HashSet();

  final OpenAPI openAPI = inject<OpenAPI>();

  Future<bool> autoSync(int year, int month) async {
    print("AutoSync Diaries..");
    if (!onlineService.isOnlineMode()) {
      print("Rejected; not online.");
      return false;
    }

    final key = "$year-$month";
    if (syncedSet.contains(key)) {
      print("Rejected; already synced..");
      return false;
    }
    syncedSet.add(key);

    Map<DateTime, DiaryIntegrityResponse> serverIntegrityMap = {};
    final integrity = await openAPI.getDiaryIntegrityByMonth(year, month);
    for (var element in integrity) {
      serverIntegrityMap[DateParser.parseYmd(element.date)] = element;
    }
    Map<DateTime, Diary> localIntegrityMap = {};
    final local = await diaryRepository.getDiaries(year, month);
    for (var element in local) {
      localIntegrityMap[element.ymd] = element;
    }
    int serverLoad = 0;
    int serverPatch = 0;
    int serverCreate = 0;

    await Future.forEach(serverIntegrityMap.entries, (element) async {
      final date = element.key;
      final serverDiary = element.value;
      if (!localIntegrityMap.containsKey(date)) {
        //서버엔 있고 로컬엔 없음 => 불러와야함
        final serverDiary =
            await openAPI.getDiaryByDate(DateParser.formatDateTime(date));
        await diaryRepository.saveDiary(serverDiary.toDomain());
        serverLoad++;
      } else {
        final localVersion = localIntegrityMap[date]!;
        if (localVersion.hash != serverDiary.contentHash ||
            localVersion.mood.toServerType() != serverDiary.emotion) {
          if (localVersion.updatedAt > serverDiary.updatedAtTs) {
            //그냥 알아서 덮어씌우면댐 ㅎ
            final newDiary = await openAPI.updateDiary(
                serverDiary.diaryId,
                DiaryUpdateRequest(
                  content: localVersion.content,
                  emotion: localVersion.mood.toServerType(),
                ));
            await diaryRepository.saveDiary(newDiary.toDomain());
            serverPatch++;
          } else {
            //나중에 GET 할떄 터질거임 ㅇㅇ
            print("UnSyncable Diary Mismatch Found");
          }
        }
      }
    });

    await Future.forEach(localIntegrityMap.entries, (element) async {
      final date = element.key;
      final localDiary = element.value;
      if (!serverIntegrityMap.containsKey(date)) {
        //로컬엔 있고 서버엔 없다 -> 저장!!
        final diaryRequest = DiaryRequest(
          content: localDiary.content,
          emotion: localDiary.mood.toServerType(),
          date: DateParser.formatDateTime(date),
        );
        final newDiary = await openAPI.createDiary(diaryRequest);
        await diaryRepository.saveDiary(newDiary.toDomain());
        serverCreate++;
      }
    });

    print(
        "AutoSync Diaries Completed. $serverLoad Loaded, $serverPatch Patched, $serverCreate Created");
    return serverLoad > 0 || serverPatch > 0 || serverCreate > 0;
  }

  Future<Diary> getDiary(
      int year, int month, int day, bool integrityCheck) async {
    final localDiary = await diaryRepository.findDiary(year, month, day);
    final today = DateTime(year, month, day);
    if (localDiary != null && onlineService.isOnlineMode()) {
      if (localDiary.diaryId != null) {
        //서버가 갖고있는 경우에
        final integrity = await openAPI.getDiaryIntegrity(localDiary.diaryId!);
        if (integrity.contentHash != localDiary.hash ||
            integrity.emotion != localDiary.mood.toServerType()) {
          if (integrity.updatedAtTs > localDiary.updatedAt) {
            //머야 왜 서버가 더 최신임? ㄷㄷ
            if (!integrityCheck) return localDiary;
            final keepLocal = await keepLocalDialog(
                localDiary.updatedAt, integrity.updatedAtTs);
            if (keepLocal == null) throw Exception();
            if (!keepLocal) {
              final serverDiaryDto = await openAPI.getDiary(integrity.diaryId);
              final serverDiary = serverDiaryDto.toDomain();
              await diaryRepository.saveDiary(serverDiary);
              return serverDiary;
            }
          }
        }
      }
    }
    return localDiary ?? Diary.create(ymd: today);
  }

  Future<Diary?> getDiaryOnServer(
      DateTime ymd,
      ) async {
    try {
      final result = await openAPI.getDiaryByDate(DateParser.formatDateTime(ymd));
      return result.toDomain();
    } catch (e) {
      return null;
    }
  }

  Future<Diary?> createDiaryOnServer(
      DateTime ymd, Mood mood, String content) async {
    try {
      final result = await openAPI.createDiary(DiaryRequest(
          date: DateParser.formatDateTime(ymd),
          emotion: mood.toServerType(),
          content: content));
      return result.toDomain();
    } catch (e) {
      return null;
    }
  }

  Future<Diary> updateDiary(
      Diary currentDiary, Mood newMood, String content) async {
    if (content.isEmpty) return currentDiary;
    final hashedContent = HashUtil.hashContent(content);
    if (hashedContent == currentDiary.hash && newMood == currentDiary.mood) {
      return currentDiary;
    }
    final isOnline = onlineService.isOnlineMode();
    String? diaryId = currentDiary.diaryId;

    Diary newDiary = currentDiary;
    try {
      if (isOnline) {
        //SAVE TO SERVER;
        final previousDiary = await getDiaryOnServer(currentDiary.ymd);
        if (previousDiary == null) {
          //FIRST SAVE
          final newSavedDiary = await createDiaryOnServer(currentDiary.ymd, newMood, content);
          diaryId = newSavedDiary?.diaryId;
        } else {
          //PATCH
          await openAPI.updateDiary(previousDiary.diaryId!, DiaryUpdateRequest(emotion: newMood.toServerType(), content: content));
        }
      } else {
        //SAVE TO UNSAVED LOCAL REPO
        SnackBarUtil.infoSnackBar(
            message: message('message_diary_saved_offline'));
      }
    } finally {
      newDiary = Diary(
        mood: newMood,
        content: content,
        ymd: currentDiary.ymd,
        hash: hashedContent,
        diaryId: diaryId,
        updatedAt: DateParser.nowAtMillis(),
      );
      await diaryRepository.saveDiary(newDiary);

    }
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
