import 'dart:convert';

import 'package:crypto/crypto.dart';

class HashUtil {
  static String hashContent(String content) =>
      sha256.convert(utf8.encode(content)).toString();

  static String emptyHash() => hashContent('');
}
