import 'dart:ui';

import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';

class Mood {
  static Mood sad = Mood(BaseColor.blue300, 'sad');
  static Mood angry = Mood(BaseColor.red300, 'angry');
  static Mood happy = Mood(BaseColor.green300, 'happy');
  static Mood amazed = Mood(BaseColor.yellow300, 'amazed');
  static Mood nervous = Mood(BaseColor.orange300, 'nervous');
  static Mood neutral = Mood(BaseColor.warmGray300, 'neutral');
  static Mood unselected = Mood(BaseColor.warmGray200, 'unselected');

  static Mood parseMood(String value) {
    switch (value.toLowerCase()) {
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
      case "unselected":
        return unselected;
      case "neutral":
      default:
        return neutral;
    }
  }

  static List<Mood> values() => [neutral, sad, angry, happy, amazed, nervous];

  final Color moodColor;
  final String name;

  String getLocalizedName() => message("generic_mood_$name");

  String toServerType() => name.toUpperCase();

  Mood(this.moodColor, this.name);
}
