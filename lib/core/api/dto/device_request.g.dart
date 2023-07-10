// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceRequest _$DeviceRequestFromJson(Map<String, dynamic> json) =>
    DeviceRequest(
      deviceToken: json['deviceToken'] as String,
      deviceInfo: json['deviceInfo'] as String,
    );

Map<String, dynamic> _$DeviceRequestToJson(DeviceRequest instance) =>
    <String, dynamic>{
      'deviceToken': instance.deviceToken,
      'deviceInfo': instance.deviceInfo,
    };
