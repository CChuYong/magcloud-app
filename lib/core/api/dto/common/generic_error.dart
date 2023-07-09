import 'package:json_annotation/json_annotation.dart';

part 'generic_error.g.dart';

@JsonSerializable()
class GenericError {
  @JsonKey(name: 'code')
  final String code;
  @JsonKey(name: 'message')
  final String message;

  GenericError(this.code, this.message);

  factory GenericError.fromJson(Map<String, dynamic> json) =>
      _$GenericErrorFromJson(json);

  Map<String, dynamic> toJson() => _$GenericErrorToJson(this);
}
