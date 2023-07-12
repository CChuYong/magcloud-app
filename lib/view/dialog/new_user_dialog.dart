import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/util/i18n.dart';
import '../component/touchableopacity.dart';
import '../designsystem/base_color.dart';

Future<void> openNewUserDialog() {
  final textController = TextEditingController();
  final focusNode = FocusNode();
  return showGeneralDialog(
    context: Get.context!,
    barrierLabel: '',
    barrierDismissible: true,
    transitionDuration: Duration(milliseconds: 350),
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
        child: child,
      );
    },
    pageBuilder: (_, _1, _2) => Dialog(
      elevation: 0.0,
      backgroundColor: BaseColor.defaultBackgroundColor,
      insetPadding: null,
      alignment: Alignment.bottomCenter,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      child: Builder(
        builder: (context) {
          var width = MediaQuery.of(context).size.width;
          return StatefulBuilder(
              builder: (ctx, setState) => SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 22.sp),
                            Text(message('generic_welcome'),
                                style: TextStyle(
                                  color: BaseColor.warmGray700,
                                  fontSize: 16.sp,
                                )),
                            SizedBox(height: 6.sp),
                            Text(message('message_welcome_description'),
                                style: TextStyle(
                                  color: BaseColor.warmGray500,
                                  fontSize: 14.sp,
                                )),
                            SizedBox(height: 15.sp),
                            SizedBox(height: 15.sp),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: TouchableOpacity(
                                        onTap: () => {
                                              Get.back(
                                                  result: textController.text)
                                            },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: BaseColor.green300,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.sp),
                                              child: Center(
                                                child: Text(
                                                    message(
                                                        'generic_lets_start'),
                                                    style: TextStyle(
                                                      color:
                                                          BaseColor.warmGray500,
                                                      fontSize: 13.sp,
                                                    )),
                                              )),
                                        ))),
                              ],
                            )
                          ],
                        )),
                  )));
        },
      ),
    ),
  );
}
