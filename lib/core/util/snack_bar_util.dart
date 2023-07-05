import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../view/designsystem/base_icon.dart';

enum SnackBarType { RED, GREEN, YELLOW, GREY }
class SnackBarUtil {
  static void errorSnackBar({
    required String message,
    SnackBarType type = SnackBarType.GREY, // neutral
    EdgeInsets margin = const EdgeInsets.all(12),
    int msDuration = 2000,
    SnackPosition position = SnackPosition.TOP,
  }) {
    print("Invoking snackbar");
    Get.snackbar(
      '',
      message,
      // backgroundColor: bgColor,
      // colorText: txtColor,
      icon: Icon(BaseIcon.snackBarError),
      titleText: Container(),
      duration: Duration(milliseconds: msDuration),
      margin: margin,
      snackPosition: position,
    );
  }

  static void infoSnackBar({
    required String message,
    SnackBarType type = SnackBarType.GREY, // neutral
    EdgeInsets margin = const EdgeInsets.all(12),
    int msDuration = 2000,
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.snackbar(
      '',
      message,
      // backgroundColor: bgColor,
      // colorText: txtColor,
      icon: Icon(BaseIcon.snackBarInfo),
      titleText: Container(),
      duration: Duration(milliseconds: msDuration),
      margin: margin,
      snackPosition: position,
    );
  }
}
