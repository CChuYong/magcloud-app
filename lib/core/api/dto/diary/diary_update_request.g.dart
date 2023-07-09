// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryUpdateRequest _$DiaryUpdateRequestFromJson(Map<String, dynamic> json) =>
    DiaryUpdateRequest(
      emotion: json['emotion'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$DiaryUpdateRequestToJson(DiaryUpdateRequest instance) =>
    <String, dynamic>{
      'emotion': instance.emotion,
      'content': instance.content,
    };
