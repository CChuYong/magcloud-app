import 'package:json_annotation/json_annotation.dart';

part 'diary_comment_request.g.dart';

@JsonSerializable()
class DiaryCommentRequest {
  @JsonKey(name: 'content')
  String content;

  DiaryCommentRequest({
    required this.content,
  });

  factory DiaryCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$DiaryCommentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryCommentRequestToJson(this);
}
