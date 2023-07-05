import 'package:injectable/injectable.dart';
import 'package:magcloud_app/core/model/mood.dart';
import 'package:magcloud_app/core/repository/base_repository.dart';
import 'package:magcloud_app/core/util/date_parser.dart';
import 'package:magcloud_app/core/util/extension.dart';
import 'package:sqflite/sqflite.dart';

import '../model/diary.dart';

@singleton
class DiaryRepository extends BaseRepository {
  DiaryRepository() : super('diaries.db', 'diaries');

  @override
  Future<void> prepareTable() async {
    await database.execute('DROP TABLE $tableName');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        diary_id TEXT PRIMARY KEY,
        ymd TEXT NOT NULL,
        content TEXT NOT NULL,
        mood TEXT NOT NULL,
        hash TEXT NOT NULL
      )
    ''');

    await database.execute('''
      CREATE UNIQUE INDEX IF NOT EXISTS ${tableName}_idx1 ON $tableName (ymd)
    ''');
  }

  Future<Diary?> findDiary(int year, int month, int day) async {
    final ymd = DateParser.formatYmd(year, month, day);
    final result = await database
        .rawQuery('SELECT * FROM $tableName WHERE ymd = ? LIMIT 1', [ymd]);
    if(result.isEmpty) return null;
    return result.first.let(readDiary);
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
  );

  Map<String, Object> writeDiary(Diary diary) => {
    "content": diary.content,
    "mood": diary.mood.name,
    "ymd": DateParser.ymdSimpleFormat.format(diary.ymd),
    "hash": diary.hash,
  };

}
