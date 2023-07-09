import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:magcloud_app/core/util/date_parser.dart';

import '../../core/util/i18n.dart';
import '../component/touchableopacity.dart';
import '../designsystem/base_color.dart';

Future<bool?> keepLocalDialog(int localTime, int serverTime) async {
  return await showGeneralDialog<bool?>(
        context: Get.context!,
        barrierLabel: '',
        barrierDismissible: true,
        transitionDuration: Duration(milliseconds: 350),
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position:
                Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
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
                                Text('무결성 알림',
                                    style: TextStyle(
                                      color: BaseColor.warmGray700,
                                      fontSize: 16.sp,
                                    )),
                                SizedBox(height: 5.sp),
                                Text('서버에 저장된 데이터가 로컬에 저장된 데이터보다 최신입니다.',
                                    style: TextStyle(
                                      color: BaseColor.warmGray500,
                                      fontSize: 14.sp,
                                    )),
                                SizedBox(height: 20.sp),
                                Container(
                                  decoration: BoxDecoration(
                                      color: BaseColor.warmGray100,
                                      borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.sp, horizontal: 15.sp),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '서버에 저장된 시간',
                                                  style: TextStyle(
                                                    color: BaseColor.warmGray700,
                                                    fontSize: 12.sp,
                                                  )
                                              ),
                                              Text(
                                                  DateParser.parseAwayFrom(serverTime),
                                                  style: TextStyle(
                                                    color: BaseColor.warmGray500,
                                                    fontSize: 12.sp,
                                                  )
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15.sp),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  '로컬에 저장된 시간',
                                                  style: TextStyle(
                                                    color: BaseColor.warmGray700,
                                                    fontSize: 12.sp,
                                                  )
                                              ),
                                              Text(
                                                  DateParser.parseAwayFrom(localTime),
                                                  style: TextStyle(
                                                    color: BaseColor.warmGray500,
                                                    fontSize: 12.sp,
                                                  )
                                              ),
                                            ],
                                          ),
                                        ],
                                      ))
                                ),
                                SizedBox(height: 15.sp),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: TouchableOpacity(
                                            onTap: () =>
                                                {Get.back(result: true)},
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: BaseColor.green200,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10.sp),
                                                  child: Center(
                                                    child: Text('로컬 일기 유지하기',
                                                        style: TextStyle(
                                                          color: BaseColor
                                                              .warmGray500,
                                                          fontSize: 13.sp,
                                                        )),
                                                  )),
                                            ))),
                                    SizedBox(width: 10.sp),
                                    Expanded(
                                        child: TouchableOpacity(
                                            onTap: () =>
                                                {Get.back(result: false)},
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: BaseColor.warmGray200,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10.sp),
                                                  child: Center(
                                                    child: Text(
                                                        '서버 버전 복구하기',
                                                        style: TextStyle(
                                                          color: BaseColor
                                                              .warmGray500,
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
      ) ;
}
