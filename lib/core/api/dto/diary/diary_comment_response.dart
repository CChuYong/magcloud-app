import 'package:json_annotation/json_annotation.dart';
import 'package:magcloud_app/core/model/mood.dart';
import 'package:magcloud_app/core/util/date_parser.dart';

import '../../../model/diary.dart';

part 'diary_comment_response.g.dart';

@JsonSerializable()
class DiaryCommentResponse {
  @JsonKey(name: 'commentId')
  String commentId;

  @JsonKey(name: 'diaryId')
  String diaryId;

  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'username')
  String username;

  @JsonKey(name: 'profileImageUrl')
  String profileImageUrl;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'createdAtTs')
  int createdAtTs;

  @JsonKey(name: 'updatedAtTs')
  int updatedAtTs;

  DiaryCommentResponse({
    required this.commentId,
    required this.diaryId,
    required this.userId,
    required this.username,
    required this.profileImageUrl,
    required this.content,
    required this.updatedAtTs,
    required this.createdAtTs,
  });

  factory DiaryCommentResponse.fromJson(Map<String, dynamic> json) =>
      _$DiaryCommentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryCommentResponseToJson(this);
}
