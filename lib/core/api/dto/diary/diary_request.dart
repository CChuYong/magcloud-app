import 'package:json_annotation/json_annotation.dart';
import 'package:magcloud_app/core/model/mood.dart';
import 'package:magcloud_app/core/model/user.dart';
import 'package:magcloud_app/core/util/date_parser.dart';

import '../../../model/diary.dart';

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
