import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  @JsonKey(name: 'accessToken')
  String accessToken;

  @JsonKey(name: 'refreshToken')
  String refreshToken;

  @JsonKey(name: 'isNewUser')
  bool isNewUser;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.isNewUser,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
