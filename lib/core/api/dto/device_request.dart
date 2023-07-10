import 'package:json_annotation/json_annotation.dart';

part 'device_request.g.dart';

@JsonSerializable()
class DeviceRequest {
  @JsonKey(name: 'deviceToken')
  String deviceToken;

  @JsonKey(name: 'deviceInfo')
  String deviceInfo;

  DeviceRequest({
    required this.deviceToken,
    required this.deviceInfo,
  });

  factory DeviceRequest.fromJson(Map<String, dynamic> json) =>
      _$DeviceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceRequestToJson(this);
}
