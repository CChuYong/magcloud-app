import 'dart:collection';

import 'package:magcloud_app/core/model/mood.dart';
import 'package:magcloud_app/core/repository/base_repository.dart';
import 'package:magcloud_app/core/util/date_parser.dart';
import 'package:magcloud_app/core/util/extension.dart';
import 'package:sqflite/sqflite.dart';

import '../model/diary.dart';

class DiaryRepository extends BaseRepository {
  DiaryRepository() : super('diaries.db', 'diaries');

  static Future<DiaryRepository> create() async {
    final DiaryRepository repository = DiaryRepository();
    await repository.initDatabase();
    return repository;
  }

  @override
  Future<void> prepareTable() async {
   // await database.execute('DROP TABLE $tableName');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        ymd TEXT NOT NULL PRIMARY KEY,
        diary_id TEXT NULL,
        content TEXT NOT NULL,
        mood TEXT NOT NULL,
        hash TEXT NOT NULL,
        updated_at LONG NOT NULL
      )
    ''');

    await database.execute('''
      CREATE INDEX IF NOT EXISTS ${tableName}_idx1 ON $tableName (mood)
    ''');
  }

  Future<Diary?> findDiary(int year, int month, int day) async {
    final ymd = DateParser.formatYmd(year, month, day);
    final result = await database
        .rawQuery('SELECT * FROM $tableName WHERE ymd = ? LIMIT 1', [ymd]);
    if (result.isEmpty) return null;
    return result.first.let(readDiary);
  }

  Future<List<Diary>> getDiaries(int year, int month) async {
    final ym = DateParser.formatYmd(year, month, 1).substring(0, 6);
    final result = await database
        .rawQuery('SELECT * FROM $tableName WHERE ymd LIKE ? ORDER BY ymd DESC', ['$ym%']);
    return result.map(readDiary).toList();
  }

  Future<Map<int, Mood>> findDailyMood(int year, int month) async {
    final ym = DateParser.formatYmd(year, month, 1).substring(0, 6);
    final result = await database
        .rawQuery("SELECT ymd, mood FROM $tableName WHERE ymd LIKE '$ym%'");
    final resultMap = HashMap<int, Mood>();
    result.forEach((row) {
      final day = int.parse((row["ymd"] as String).substring(6, 8));
      resultMap[day] = Mood.parseMood(row["mood"] as String);
    });
    return resultMap;
  }

  Future<Map<int, Mood>> findMonthlyMood(int year) async {
    final resultMap = HashMap<int, Mood>();
    for (int month = 1; month <= 12; month++) {
      final ym = DateParser.formatYmd(year, month, 1).substring(0, 6);
      final result = await database.rawQuery(
          "SELECT mood, COUNT(mood) cnt FROM $tableName WHERE ymd LIKE '$ym%' GROUP BY mood ORDER BY COUNT(mood) LIMIT 1");
      if (result.isNotEmpty)
        resultMap[month] = Mood.parseMood(result.first["mood"] as String);
    }
    return resultMap;
  }

  Future<Diary> saveDiary(Diary diary) async {
    await database.insert(
      tableName,
      writeDiary(diary),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return diary;
  }

  Diary readDiary(Map<String, Object?> row) => Diary(
        content: (row["content"] as String),
        mood: Mood.parseMood(row["mood"] as String),
        ymd: DateParser.parseYmd(row["ymd"] as String),
        hash: row["hash"] as String,
        diaryId: row["diary_id"]?.let((p0) => p0 as String?),
        updatedAt: row["updated_at"] as int,
      );

  Map<String, Object?> writeDiary(Diary diary) => {
        "content": diary.content,
        "mood": diary.mood.name,
        "ymd": DateParser.ymdSimpleFormat.format(diary.ymd),
        "hash": diary.hash,
        "diary_id": diary.diaryId,
    "updated_at": diary.updatedAt,
      };
}
