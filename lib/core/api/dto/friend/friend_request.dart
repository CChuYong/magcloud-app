import 'package:json_annotation/json_annotation.dart';

part 'friend_request.g.dart';

@JsonSerializable()
class FriendRequest {
  @JsonKey(name: 'tag')
  String tag;

  FriendRequest({
    required this.tag,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FriendRequestToJson(this);
}
