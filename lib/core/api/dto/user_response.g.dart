// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
      userId: json['userId'] as String,
      name: json['name'] as String,
      nameTag: json['nameTag'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
    );

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'nameTag': instance.nameTag,
      'profileImageUrl': instance.profileImageUrl,
    };
