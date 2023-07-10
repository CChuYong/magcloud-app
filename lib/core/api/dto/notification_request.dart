import 'package:json_annotation/json_annotation.dart';

part 'notification_request.g.dart';

@JsonSerializable()
class NotificationRequest {
  @JsonKey(name: 'app')
  bool app;

  @JsonKey(name: 'social')
  bool social;

  NotificationRequest({
    required this.app,
    required this.social,
  });

  factory NotificationRequest.fromJson(Map<String, dynamic> json) =>
      _$NotificationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationRequestToJson(this);
}
