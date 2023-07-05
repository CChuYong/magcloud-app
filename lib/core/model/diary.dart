import 'mood.dart';

class Diary {
  final Mood mood;
  final DateTime ymd;
  final String content;
  final String hash;
  Diary({required this.mood, required this.content, required this.ymd, required this.hash});
}
