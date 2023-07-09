import 'package:json_annotation/json_annotation.dart';

part 'profile_image_update_request.g.dart';

@JsonSerializable()
class ProfileImageUpdateRequest {
  @JsonKey(name: 'profileImageUrl')
  String profileImageUrl;

  ProfileImageUpdateRequest({
    required this.profileImageUrl,
  });

  factory ProfileImageUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ProfileImageUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileImageUpdateRequestToJson(this);
}
