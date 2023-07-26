import 'dart:ui';

import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';

class Mood {
  static Mood sad = Mood(BaseColor.blue300, 'sad', [const Color(0xff0EA5E9), const Color(0xff0369A1), const Color(0xff075985), const Color(0xff0EA5E9)]);
  static Mood angry = Mood(BaseColor.red300, 'angry', [const Color(0xffEF4444), const Color(0xffB91C1C), const Color(0xff991B1B), const Color(0xffEF4444)]);
  static Mood happy = Mood(BaseColor.green300, 'happy', [const Color(0xff86EFAC), const Color(0xff22C55E), const Color(0xff16A34A), const Color(0xff86EFAC)]);
  static Mood amazed = Mood(BaseColor.yellow300, 'amazed', [const Color(0xffFACC15), const Color(0xffCA8A04), const Color(0xffA16207), const Color(0xffFACC15)]);
  static Mood nervous = Mood(BaseColor.orange300, 'nervous', [const Color(0xffF97316), const Color(0xffC2410C), const Color(0xffEA580C), const Color(0xffF97316)]);
  static Mood neutral = Mood(BaseColor.warmGray300, 'neutral', [BaseColor.warmGray300, BaseColor.warmGray400, BaseColor.warmGray500, BaseColor.warmGray300]);
  static Mood unselected = Mood(BaseColor.warmGray200, 'unselected', [BaseColor.warmGray200, BaseColor.warmGray200]);

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
  final List<Color> gradientMoodColor;

  String getLocalizedName() => message("generic_mood_$name");

  String toServerType() => name.toUpperCase();

  Mood(this.moodColor, this.name, this.gradientMoodColor);
}
