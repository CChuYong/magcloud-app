// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_comment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryCommentResponse _$DiaryCommentResponseFromJson(
        Map<String, dynamic> json) =>
    DiaryCommentResponse(
      commentId: json['commentId'] as String,
      diaryId: json['diaryId'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      content: json['content'] as String,
      updatedAtTs: json['updatedAtTs'] as int,
      createdAtTs: json['createdAtTs'] as int,
    );

Map<String, dynamic> _$DiaryCommentResponseToJson(
        DiaryCommentResponse instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'diaryId': instance.diaryId,
      'userId': instance.userId,
      'username': instance.username,
      'profileImageUrl': instance.profileImageUrl,
      'content': instance.content,
      'createdAtTs': instance.createdAtTs,
      'updatedAtTs': instance.updatedAtTs,
    };
