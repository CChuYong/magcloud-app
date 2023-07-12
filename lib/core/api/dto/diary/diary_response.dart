import 'package:json_annotation/json_annotation.dart';
import 'package:magcloud_app/core/model/mood.dart';
import 'package:magcloud_app/core/util/date_parser.dart';

import '../../../model/diary.dart';

part 'diary_response.g.dart';

@JsonSerializable()
class DiaryResponse {
  @JsonKey(name: 'diaryId')
  String diaryId;

  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'date')
  String date;

  @JsonKey(name: 'emotion')
  String emotion;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'contentHash')
  String contentHash;

  @JsonKey(name: 'createdAtTs')
  int createdAtTs;

  @JsonKey(name: 'updatedAtTs')
  int updatedAtTs;

  DiaryResponse({
    required this.diaryId,
    required this.userId,
    required this.date,
    required this.emotion,
    required this.content,
    required this.contentHash,
    required this.updatedAtTs,
    required this.createdAtTs,
  });

  factory DiaryResponse.fromJson(Map<String, dynamic> json) =>
      _$DiaryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryResponseToJson(this);

  Diary toDomain() => Diary(
      diaryId: diaryId,
      mood: Mood.parseMood(emotion),
      content: content,
      ymd: DateParser.parseYmd(date),
      hash: contentHash,
      updatedAt: updatedAtTs);
}
