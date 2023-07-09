// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageUploadResponse _$ImageUploadResponseFromJson(Map<String, dynamic> json) =>
    ImageUploadResponse(
      downloadUrl: json['downloadUrl'] as String,
      uploadUrl: json['uploadUrl'] as String,
    );

Map<String, dynamic> _$ImageUploadResponseToJson(
        ImageUploadResponse instance) =>
    <String, dynamic>{
      'downloadUrl': instance.downloadUrl,
      'uploadUrl': instance.uploadUrl,
    };
