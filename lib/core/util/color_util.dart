import 'dart:ui';

class ColorUtil {
  static String colorToHex(Color color) {
    final hexString = color.value.toRadixString(16);
    return hexString.substring(2, hexString.length);
  }
}
