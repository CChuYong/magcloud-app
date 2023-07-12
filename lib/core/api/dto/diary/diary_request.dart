import 'package:json_annotation/json_annotation.dart';

part 'diary_request.g.dart';

@JsonSerializable()
class DiaryRequest {
  @JsonKey(name: 'date')
  String date;

  @JsonKey(name: 'emotion')
  String emotion;

  @JsonKey(name: 'content')
  String content;

  DiaryRequest({
    required this.date,
    required this.emotion,
    required this.content,
  });

  factory DiaryRequest.fromJson(Map<String, dynamic> json) =>
      _$DiaryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryRequestToJson(this);
}
