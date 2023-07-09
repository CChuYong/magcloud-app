import 'package:magcloud_app/core/model/user.dart';

import 'mood.dart';

class DailyUser extends User {
  final Mood mood;

  DailyUser({required super.userId,
      required super.name,
      required super.nameTag,
      required this.mood,
    required super.profileImageUrl,
      });
}
