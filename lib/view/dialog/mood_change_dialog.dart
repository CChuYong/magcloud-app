import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/model/mood.dart';
import '../../core/util/i18n.dart';
import '../component/touchableopacity.dart';
import '../designsystem/base_color.dart';

Future<Mood?> moodChangeDialog({
  required Mood previousMood,
}) {
  Mood selectedMood = previousMood;
  return showGeneralDialog<Mood?>(
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
                            Text(message('generic_select_emotion'),
                                style: TextStyle(
                                  color: BaseColor.warmGray700,
                                  fontSize: 14.sp,
                                )),
                            SizedBox(height: 18.sp),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: Mood.values().map((mood) {
                                return moodBar(mood, mood == selectedMood, () {
                                  setState(() {
                                    selectedMood = mood;
                                  });
                                });
                              }).toList(),
                            ),
                            SizedBox(height: 30.sp),
                            TouchableOpacity(
                                onTap: () => Get.back(result: selectedMood),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: BaseColor.warmGray200,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.sp),
                                      child: Center(
                                        child: Text(message('generic_apply'),
                                            style: TextStyle(
                                              color: BaseColor.warmGray600,
                                              fontSize: 13.sp,
                                            )),
                                      )),
                                ))
                          ],
                        )),
                  )));
        },
      ),
    ),
  );
}

Widget moodBar(Mood mood, bool isSelected, void Function() onTap) {
  return Column(children: [
    TouchableOpacity(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40.sp,
              height: 40.sp,
              decoration: BoxDecoration(
                color: mood.moodColor,
                shape: BoxShape.circle,
              ),
            ),
            isSelected
                ? Icon(Icons.check, size: 20.sp, color: BaseColor.warmGray600)
                : Container(),
          ],
        )),
    SizedBox(height: 3.sp),
    Text(mood.getLocalizedName(),
        style: TextStyle(color: BaseColor.warmGray500, fontSize: 12.sp))
  ]);
}
