import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../designsystem/base_color.dart';

Future<void> imagePreviewDialog(String imageUrl) {
  return showGeneralDialog(
    context: Get.context!,
    barrierLabel: '',
    barrierDismissible: true,
    pageBuilder: (_, _1, _2) => Dialog(
      backgroundColor: BaseColor.defaultBackgroundColor,
      insetPadding: null,
      alignment: Alignment.center,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      child: Builder(
        builder: (context) {
          final width = MediaQuery.of(context).size.width - 30.sp;
          return StatefulBuilder(
              builder: (ctx, setState) => Container(
                    width: width,
                    height: width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(imageUrl),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ));
        },
      ),
    ),
  );
}
