// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_integrity_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryIntegrityResponse _$DiaryIntegrityResponseFromJson(
        Map<String, dynamic> json) =>
    DiaryIntegrityResponse(
      diaryId: json['diaryId'] as String,
      contentHash: json['contentHash'] as String,
      emotion: json['emotion'] as String,
      updatedAtTs: json['updatedAtTs'] as int,
      createdAtTs: json['createdAtTs'] as int,
    );

Map<String, dynamic> _$DiaryIntegrityResponseToJson(
        DiaryIntegrityResponse instance) =>
    <String, dynamic>{
      'diaryId': instance.diaryId,
      'contentHash': instance.contentHash,
      'emotion': instance.emotion,
      'createdAtTs': instance.createdAtTs,
      'updatedAtTs': instance.updatedAtTs,
    };
