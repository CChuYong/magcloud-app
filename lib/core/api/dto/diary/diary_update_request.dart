import 'package:json_annotation/json_annotation.dart';

part 'diary_update_request.g.dart';

@JsonSerializable()
class DiaryUpdateRequest {
  @JsonKey(name: 'emotion')
  String emotion;

  @JsonKey(name: 'content')
  String content;

  DiaryUpdateRequest({
    required this.emotion,
    required this.content,
  });

  factory DiaryUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$DiaryUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryUpdateRequestToJson(this);
}
