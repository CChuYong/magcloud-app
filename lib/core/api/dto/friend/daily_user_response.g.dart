// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyUserResponse _$DailyUserResponseFromJson(Map<String, dynamic> json) =>
    DailyUserResponse(
      userId: json['userId'] as String,
      name: json['name'] as String,
      nameTag: json['nameTag'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      emotion: json['emotion'] as String,
    );

Map<String, dynamic> _$DailyUserResponseToJson(DailyUserResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'nameTag': instance.nameTag,
      'profileImageUrl': instance.profileImageUrl,
      'emotion': instance.emotion,
    };
