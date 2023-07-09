// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_refresh_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRefreshRequest _$AuthRefreshRequestFromJson(Map<String, dynamic> json) =>
    AuthRefreshRequest(
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$AuthRefreshRequestToJson(AuthRefreshRequest instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
    };
