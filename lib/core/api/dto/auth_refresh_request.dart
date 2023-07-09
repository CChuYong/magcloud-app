import 'package:json_annotation/json_annotation.dart';

part 'auth_refresh_request.g.dart';

@JsonSerializable()
class AuthRefreshRequest {
  @JsonKey(name: 'refreshToken')
  String refreshToken;

  AuthRefreshRequest({
    required this.refreshToken,
  });

  factory AuthRefreshRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthRefreshRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AuthRefreshRequestToJson(this);
}
