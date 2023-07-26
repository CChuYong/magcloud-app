import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:magcloud_app/core/util/hash_util.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';

import '../../core/model/user.dart';

class TaggableTextEditingController extends TextEditingController {
  final HashMap<String, User> mappedUser = HashMap();
  void addUser(User user) {
    mappedUser[user.userId] = user;
  }

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    final textList = toParsedString(text);
    return TextSpan(
      children: textList.map((chars) {
        if(chars.startsWith("@")) {
          final id = chars.substring(1);
          if(HashUtil.isULID(id)){
            String nameChar = mappedUser[id]?.name ?? chars;
            final requiredZeroSize = 27 - nameChar.length;
            return TextSpan(
              children: [
                TextSpan(
                  text: nameChar,
                  style: style?.copyWith(color: BaseColor.green300, fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '\u200b' * (requiredZeroSize))
              ],

            );
          }
        } else if(chars.startsWith("#")) {
          return TextSpan(
            text: chars,
            style: style?.copyWith(color: BaseColor.blue300 , fontWeight: FontWeight.bold),
          );
        }
        return TextSpan(
          text: chars,
          style: style,
        );
      }).toList()
    );
  }

  List<String> toParsedString(String text) {
    RegExp regex = RegExp(r"([@#]\S+)");

    List<String> result = [];
    int currentIndex = 0;

    for (RegExpMatch match in regex.allMatches(text)) {
      if (currentIndex < match.start) {
        result.add(text.substring(currentIndex, match.start));
      }
      result.add(match.group(0) ?? '');
      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      result.add(text.substring(currentIndex));
    }
    return result;
  }
}
