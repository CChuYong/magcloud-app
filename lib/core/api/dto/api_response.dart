import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable()
class APIResponse {
  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'message')
  String message;

  APIResponse({
    required this.success,
    required this.message,
  });

  factory APIResponse.fromJson(Map<String, dynamic> json) =>
      _$APIResponseFromJson(json);

  Map<String, dynamic> toJson() => _$APIResponseToJson(this);
}
