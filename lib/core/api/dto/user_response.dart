import 'package:json_annotation/json_annotation.dart';
import 'package:magcloud_app/core/model/user.dart';

part 'user_response.g.dart';

@JsonSerializable()
class UserResponse {
  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'nameTag')
  String nameTag;

  @JsonKey(name: 'profileImageUrl')
  String profileImageUrl;

  UserResponse({
    required this.userId,
    required this.name,
    required this.nameTag,
    required this.profileImageUrl,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);

  User toDomain() => User(userId: userId, name: name, nameTag: nameTag, profileImageUrl: profileImageUrl);
}
