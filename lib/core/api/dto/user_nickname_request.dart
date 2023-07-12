import 'package:json_annotation/json_annotation.dart';

part 'user_nickname_request.g.dart';

@JsonSerializable()
class UserNickNameRequest {
  @JsonKey(name: 'name')
  String name;

  UserNickNameRequest({
    required this.name,
  });

  factory UserNickNameRequest.fromJson(Map<String, dynamic> json) =>
      _$UserNickNameRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserNickNameRequestToJson(this);
}
