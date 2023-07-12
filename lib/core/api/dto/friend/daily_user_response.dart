import 'package:json_annotation/json_annotation.dart';
import 'package:magcloud_app/core/model/daily_user.dart';
import 'package:magcloud_app/core/model/mood.dart';

part 'daily_user_response.g.dart';

@JsonSerializable()
class DailyUserResponse {
  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'nameTag')
  String nameTag;

  @JsonKey(name: 'profileImageUrl')
  String profileImageUrl;

  @JsonKey(name: 'emotion')
  String emotion;

  DailyUserResponse({
    required this.userId,
    required this.name,
    required this.nameTag,
    required this.profileImageUrl,
    required this.emotion,
  });

  factory DailyUserResponse.fromJson(Map<String, dynamic> json) =>
      _$DailyUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DailyUserResponseToJson(this);

  DailyUser toDomain() => DailyUser(
      userId: userId,
      name: name,
      nameTag: nameTag,
      profileImageUrl: profileImageUrl,
      mood: Mood.parseMood(emotion));
}
