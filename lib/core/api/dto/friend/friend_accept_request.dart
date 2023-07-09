import 'package:json_annotation/json_annotation.dart';

part 'friend_accept_request.g.dart';

@JsonSerializable()
class FriendAcceptRequest {
  @JsonKey(name: 'userId')
  String userId;

  FriendAcceptRequest({
    required this.userId,
  });

  factory FriendAcceptRequest.fromJson(Map<String, dynamic> json) =>
      _$FriendAcceptRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FriendAcceptRequestToJson(this);
}
