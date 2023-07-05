import 'package:injectable/injectable.dart';
import 'package:magcloud_app/core/model/diary.dart';
import 'package:magcloud_app/core/model/mood.dart';

@injectable
class DiaryService {
  Future<Diary> getDiary(int year, int month, int day) async {
    return Diary(mood: Mood.sad, content: '엄준식이었어요..');
  }
}
