import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../core/model/mood.dart';
import '../../core/util/i18n.dart';
import '../component/touchableopacity.dart';
import '../designsystem/base_color.dart';

Future<bool> confirmDialog(String title, String subtitle, {required String confirmText}) async {
  return await showGeneralDialog<bool?>(
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
                            Text(title,
                                style: TextStyle(
                                  color: BaseColor.warmGray700,
                                  fontSize: 16.sp,
                                )),
                            Text(subtitle,
                                style: TextStyle(
                                  color: BaseColor.warmGray500,
                                  fontSize: 14.sp,
                                )),
                            SizedBox(height: 15.sp),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: TouchableOpacity(
                                    onTap: () => {Get.back(result: true)},
                                    child:
                                    Container(
                                      decoration: BoxDecoration(
                                          color: BaseColor.green200,
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Padding(
                                          padding:
                                          EdgeInsets.symmetric(vertical: 10.sp),
                                          child: Center(
                                            child: Text(confirmText,
                                                style: TextStyle(
                                                  color: BaseColor.warmGray500,
                                                  fontSize: 13.sp,
                                                )),
                                          )),
                                    )))
                                ,
                                SizedBox(width: 10.sp),
                                Expanded(child: TouchableOpacity(
                                    onTap: () => {Get.back(result: false)},
                                    child:
                                    Container(
                                      decoration: BoxDecoration(
                                          color: BaseColor.warmGray200,
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Padding(
                                          padding:
                                          EdgeInsets.symmetric(vertical: 10.sp),
                                          child: Center(
                                            child: Text(message('generic_cancel'),
                                                style: TextStyle(
                                                  color: BaseColor.warmGray500,
                                                  fontSize: 13.sp,
                                                )),
                                          )),
                                    )))
                              ],
                            )

                          ],
                        )),
                  )));
        },
      ),
    ),
  ) ?? false;
}
