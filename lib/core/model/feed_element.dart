import 'package:magcloud_app/core/model/diary.dart';
import 'package:magcloud_app/core/model/user.dart';
import 'mood.dart';

class FeedElement {
  final String userId;
  final String userName;
  final String profileImageUrl;
  final String diaryId;
  final Mood mood;
  final DateTime ymd;
  final String content;
  final int createdAt;

  FeedElement({
    required this.userId,
    required this.userName,
    required this.profileImageUrl,
    required this.diaryId,
    required this.mood,
    required this.ymd,
    required this.content,
    required this.createdAt,
  });

  static FeedElement create(Diary diary, User user) =>
      FeedElement(
        userId: user.userId,
        userName: user.name,
        profileImageUrl: user.profileImageUrl,
        diaryId: diary.diaryId ?? '',
        mood: diary.mood,
        ymd: diary.ymd,
        content: diary.content,
        createdAt: diary.updatedAt,
      );
}
