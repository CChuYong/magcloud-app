// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenericError _$GenericErrorFromJson(Map<String, dynamic> json) => GenericError(
      json['code'] as String,
      json['message'] as String,
    );

Map<String, dynamic> _$GenericErrorToJson(GenericError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
