// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryRequest _$DiaryRequestFromJson(Map<String, dynamic> json) => DiaryRequest(
      date: json['date'] as String,
      emotion: json['emotion'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$DiaryRequestToJson(DiaryRequest instance) =>
    <String, dynamic>{
      'date': instance.date,
      'emotion': instance.emotion,
      'content': instance.content,
    };
