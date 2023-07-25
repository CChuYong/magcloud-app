import 'package:json_annotation/json_annotation.dart';
import 'package:magcloud_app/core/model/feed_element.dart';

import '../../../model/mood.dart';

part 'feed_response.g.dart';

@JsonSerializable()
class FeedResponse {
  @JsonKey(name: 'userId')
  final String userId;
  @JsonKey(name: 'userName')
  final String userName;
  @JsonKey(name: 'profileImageUrl')
  final String profileImageUrl;
  @JsonKey(name: 'diaryId')
  final String diaryId;
  @JsonKey(name: 'mood')
  final String mood;
  @JsonKey(name: 'ymd')
  final String ymd;
  @JsonKey(name: 'content')
  final String content;
  @JsonKey(name: "isLiked")
  final bool isLiked;
  @JsonKey(name: "likeCount")
  final int likeCount;
  @JsonKey(name: "imageUrl")
  final String? imageUrl;
  @JsonKey(name: 'createdAtTs')
  final int createdAtTs;
  @JsonKey(name: 'commentCount')
  final int commentCount;

  FeedResponse({
    required this.userId,
    required this.userName,
    required this.profileImageUrl,
    required this.diaryId,
    required this.mood,
    required this.ymd,
    required this.content,
    required this.isLiked,
    required this.likeCount,
    required this.createdAtTs,
    required this.imageUrl,
    required this.commentCount,
  });

  factory FeedResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FeedResponseToJson(this);

  FeedElement toDomain() => FeedElement(
        userId: userId,
        userName: userName,
        profileImageUrl: profileImageUrl,
        diaryId: diaryId,
        mood: Mood.parseMood(mood),
        ymd: DateTime.parse(ymd),
        content: content,
        imageUrl: imageUrl,
        likeCount: likeCount,
        commentCount: commentCount,
        isLiked: isLiked,
        createdAt: createdAtTs,
      );
}
