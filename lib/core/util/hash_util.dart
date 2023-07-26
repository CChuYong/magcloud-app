import 'dart:convert';

import 'package:crypto/crypto.dart';

class HashUtil {
  static String hashContent(String content) =>
      sha256.convert(utf8.encode(content)).toString();

  static String emptyHash() => hashContent('');

  static final RegExp ulidRegex = RegExp(r'^[0-9A-Za-z]{26}$');
  static bool isULID(String input) {
    return ulidRegex.hasMatch(input);
  }
}
