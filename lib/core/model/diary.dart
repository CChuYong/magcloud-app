import 'package:magcloud_app/core/util/hash_util.dart';

import 'mood.dart';

class Diary {
  final Mood mood;
  final DateTime ymd;
  final String content;
  final String hash;

  Diary(
      {required this.mood,
      required this.content,
      required this.ymd,
      required this.hash});

  static Diary mock({DateTime? ymd}) => Diary(mood: Mood.neutral, content: '', ymd: ymd ?? DateTime.now(), hash: HashUtil.emptyHash());
}
