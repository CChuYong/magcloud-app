import 'dart:ui';

import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';

class Mood {
  static Mood sad = Mood(BaseColor.blue300, message("generic_mood_sad"), 'sad');
  static Mood angry =
      Mood(BaseColor.red300, message("generic_mood_angry"), 'angry');
  static Mood happy =
      Mood(BaseColor.green300, message("generic_mood_happy"), 'happy');
  static Mood amazed =
      Mood(BaseColor.yellow300, message("generic_mood_amazed"), 'amazed');
  static Mood nervous =
      Mood(BaseColor.orange300, message("generic_mood_nervous"), 'nervous');
  static Mood neutral =
      Mood(BaseColor.warmGray300, message("generic_mood_neutral"), 'neutral');

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
      case "neutral":
      default:
        return neutral;
    }
  }

  final Color moodColor;
  final String localizedName;
  final String name;

  Mood(this.moodColor, this.localizedName, this.name);
}
