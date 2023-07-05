import 'dart:ui';

import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';

class Mood {
  static Mood sad = Mood(BaseColor.red400, message("generic_mood_sad"));
  static Mood angry = Mood(BaseColor.red400, message("generic_mood_angry"));
  static Mood happy = Mood(BaseColor.red400, message("generic_mood_happy"));
  static Mood amazed = Mood(BaseColor.red400, message("generic_mood_amazed"));
  static Mood nervous = Mood(BaseColor.red400, message("generic_mood_nervous"));

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
