// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryResponse _$DiaryResponseFromJson(Map<String, dynamic> json) =>
    DiaryResponse(
      diaryId: json['diaryId'] as String,
      userId: json['userId'] as String,
      date: json['date'] as String,
      emotion: json['emotion'] as String,
      content: json['content'] as String,
      contentHash: json['contentHash'] as String,
      updatedAtTs: json['updatedAtTs'] as int,
      createdAtTs: json['createdAtTs'] as int,
    );

Map<String, dynamic> _$DiaryResponseToJson(DiaryResponse instance) =>
    <String, dynamic>{
      'diaryId': instance.diaryId,
      'userId': instance.userId,
      'date': instance.date,
      'emotion': instance.emotion,
      'content': instance.content,
      'contentHash': instance.contentHash,
      'createdAtTs': instance.createdAtTs,
      'updatedAtTs': instance.updatedAtTs,
    };
