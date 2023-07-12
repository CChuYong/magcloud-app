import 'package:magcloud_app/core/model/user.dart';

class Friend extends User {
  final bool isDiaryShared;

  Friend(
      {required super.userId,
      required super.name,
      required super.nameTag,
      required super.profileImageUrl,
      required this.isDiaryShared});
}
