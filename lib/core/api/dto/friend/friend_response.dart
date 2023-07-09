import 'package:json_annotation/json_annotation.dart';
import 'package:magcloud_app/core/model/friend.dart';
import 'package:magcloud_app/core/model/user.dart';

part 'friend_response.g.dart';

@JsonSerializable()
class FriendResponse {
  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'nameTag')
  String nameTag;

  @JsonKey(name: 'profileImageUrl')
  String profileImageUrl;

  @JsonKey(name: 'isDiaryShared')
  bool isDiaryShared;

  FriendResponse({
    required this.userId,
    required this.name,
    required this.nameTag,
    required this.profileImageUrl,
    required this.isDiaryShared,
  });

  factory FriendResponse.fromJson(Map<String, dynamic> json) =>
      _$FriendResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FriendResponseToJson(this);

  Friend toDomain() => Friend(userId: userId, name: name, nameTag: nameTag, profileImageUrl: profileImageUrl, isDiaryShared: isDiaryShared);
}
