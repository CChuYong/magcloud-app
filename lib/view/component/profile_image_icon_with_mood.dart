import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/model/mood.dart';

class ProfileImageIconWithMood extends StatelessWidget {
  final double baseSize;
  final Mood mood;
  final String? url;

  const ProfileImageIconWithMood({Key? key, required this.baseSize, required this.mood, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: (baseSize + 8).sp,
          height: (baseSize + 8).sp,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient:  SweepGradient(
                colors: mood.gradientMoodColor,
              )
          ),
        ),
        Container(
          width: (baseSize + 3).sp,
          height: (baseSize + 3).sp,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.theme.colorScheme.background,
          ),
        ),

        Container(
          width: baseSize.sp,
          height: baseSize.sp,
          decoration: BoxDecoration(
            color: context.theme.colorScheme.onBackground,
            shape: BoxShape.circle,
            image: url != null
                ? DecorationImage(
              image: CachedNetworkImageProvider(url!),
              fit: BoxFit.cover,
            )
                : null,
          ),
        ),


      ],
    );
  }
}
