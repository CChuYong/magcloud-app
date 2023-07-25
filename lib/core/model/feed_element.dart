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
  final String? imageUrl;
  final bool isLiked;
  final int likeCount;
  final int commentCount;
  final int createdAt;

  FeedElement({
    required this.userId,
    required this.userName,
    required this.profileImageUrl,
    required this.diaryId,
    required this.mood,
    required this.ymd,
    required this.content,
    required this.imageUrl,
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
  });

  @override
  int get hashCode => diaryId.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is FeedElement) {
      return diaryId == other.diaryId;
    }
    return false;
  }
}
