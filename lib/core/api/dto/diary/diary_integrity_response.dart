import 'package:json_annotation/json_annotation.dart';
import 'package:magcloud_app/core/model/mood.dart';
import 'package:magcloud_app/core/model/user.dart';
import 'package:magcloud_app/core/util/date_parser.dart';

import '../../../model/diary.dart';

part 'diary_integrity_response.g.dart';

@JsonSerializable()
class DiaryIntegrityResponse {
  @JsonKey(name: 'diaryId')
  String diaryId;

  @JsonKey(name: 'contentHash')
  String contentHash;

  @JsonKey(name: 'emotion')
  String emotion;

  @JsonKey(name: 'createdAtTs')
  int createdAtTs;

  @JsonKey(name: 'updatedAtTs')
  int updatedAtTs;

  DiaryIntegrityResponse({
    required this.diaryId,
    required this.contentHash,
    required this.emotion,
    required this.updatedAtTs,
    required this.createdAtTs,
  });

  factory DiaryIntegrityResponse.fromJson(Map<String, dynamic> json) =>
      _$DiaryIntegrityResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryIntegrityResponseToJson(this);
}
