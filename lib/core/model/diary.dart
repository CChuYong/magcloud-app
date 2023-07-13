import 'package:magcloud_app/core/util/hash_util.dart';

import '../util/date_parser.dart';
import 'mood.dart';

class Diary {
  final String? diaryId;
  final Mood mood;
  final DateTime ymd;
  final String content;
  final String hash;
  final String? imageUrl;
  final int updatedAt;

  Diary({
    required this.mood,
    required this.content,
    required this.ymd,
    required this.hash,
    required this.diaryId,
    required this.imageUrl,
    required this.updatedAt,
  });

  static Diary create({DateTime? ymd}) => Diary(
      diaryId: null,
      mood: Mood.neutral,
      content: '',
      ymd: ymd ?? DateTime.now(),
      imageUrl: null,
      updatedAt: DateParser.nowAtMillis(),
      hash: HashUtil.emptyHash());
}
