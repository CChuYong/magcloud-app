import 'package:json_annotation/json_annotation.dart';

part 'image_upload_response.g.dart';

@JsonSerializable()
class ImageUploadResponse {
  @JsonKey(name: 'downloadUrl')
  String downloadUrl;

  @JsonKey(name: 'uploadUrl')
  String uploadUrl;

  ImageUploadResponse({
    required this.downloadUrl,
    required this.uploadUrl,
  });

  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$ImageUploadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ImageUploadResponseToJson(this);
}
