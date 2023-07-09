// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendResponse _$FriendResponseFromJson(Map<String, dynamic> json) =>
    FriendResponse(
      userId: json['userId'] as String,
      name: json['name'] as String,
      nameTag: json['nameTag'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      isDiaryShared: json['isDiaryShared'] as bool,
    );

Map<String, dynamic> _$FriendResponseToJson(FriendResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'nameTag': instance.nameTag,
      'profileImageUrl': instance.profileImageUrl,
      'isDiaryShared': instance.isDiaryShared,
    };
