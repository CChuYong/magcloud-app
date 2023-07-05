import 'dart:ui';

import 'package:magcloud_app/view/designsystem/base_color.dart';

class Mood {
  static Mood sad = Mood(BaseColor.red400, '슬픈');
  static Mood angry = Mood(BaseColor.red400, '화난');
  static Mood happy = Mood(BaseColor.red400, '행복한');
  static Mood amazed = Mood(BaseColor.red400, '놀란');
  static Mood nervous = Mood(BaseColor.red400, '긴장된');

  static Mood parseMood(String value) {
    switch(value.toLowerCase()) {
      case "sad":
        return sad;
      case "angry":
        return angry;
      case "happy":
        return happy;
      case "amazed":
        return amazed;
      case "nervous":
        return nervous;
      default:
        throw Exception();
    }
  }

  final Color moodColor;
  final String localizedName;
  Mood(this.moodColor, this.localizedName);
}
