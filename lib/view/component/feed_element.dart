import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:magcloud_app/core/model/feed_element.dart';
import 'package:magcloud_app/core/util/extension.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';

import '../../core/util/date_parser.dart';
import '../../core/util/font.dart';
import '../../core/util/i18n.dart';
import '../designsystem/base_color.dart';
import '../dialog/image_preview_dialog.dart';

class FeedElementView extends StatelessWidget {
  FeedElement element;
  double width;
  void Function(FeedElement element)? onTapProfileImage;
  void Function(FeedElement element)? onTapLike;
  void Function(FeedElement element)? onTapUnlike;
  void Function(FeedElement element)? onTapComment;


  FeedElementView(this.element, this.width, {super.key, this.onTapProfileImage, this.onTapLike, this.onTapUnlike, this.onTapComment});
  @override
  Widget build(BuildContext context) {
    final divider = Divider(color: context.theme.colorScheme.outline, thickness: 1.sp);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        divider,
        SizedBox(height: 8.sp),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TouchableOpacity(
                        onTap: () => onTapProfileImage?.let((it) => it(element)),
                        child: friendProfileIcon(
                            element.mood.moodColor, element.profileImageUrl)),
                    SizedBox(width: 8.sp),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          element.userName,
                          style: TextStyle(
                              color: context.theme.colorScheme.primary,
                              fontSize: 14.sp,
                              height: 1.3,
                              fontFamily: 'Pretendard'),
                        ),
                        Text(
                          message('generic_created_before').format(
                              [DateParser.gapBetweenNow(element.createdAt)]),
                          style: TextStyle(
                              color: context.theme.colorScheme.secondary,
                              fontSize: 12.sp,
                              height: 1.3,
                              fontFamily: 'Pretendard'),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TouchableOpacity(
                        onTap: element.isLiked ? () => onTapUnlike?.let((it) => it(element)) : () => onTapLike?.let((it) => it(element)),
                        child: Container(
                          //  width: 33.sp,
                          height: 33.sp,
                          //color: Colors.blueAccent,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Icon(Icons.calendar_today_outlined, size: 18.sp, color: BaseColor.warmGray400),
                                element.isLiked ? Icon(CupertinoIcons.suit_heart_fill,
                                    size: 18.sp, color: BaseColor.red400) : Icon(CupertinoIcons.suit_heart,
                                    size: 18.sp, color: BaseColor.red400),
                                SizedBox(width: 3.sp),
                                Text(element.likeCount.toString(), style: TextStyle(
                                    fontSize: 17.sp,
                                    height: 1.0,
                                    color: context.theme.colorScheme.secondary
                                ))
                              ]),
                          //  color: BaseColor.blue300,
                        )),
                    SizedBox(width: 10.sp),
                    TouchableOpacity(
                        onTap: () => onTapComment?.let((it) => it(element)),
                        child: Container(
                          //  width: 33.sp,
                          height: 33.sp,
                          //color: Colors.blueAccent,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.chat_bubble_outline_rounded,
                                    size: 20.sp, color: BaseColor.warmGray300),
                                SizedBox(width: 3.sp),
                                Text(element.commentCount.toString(), style: TextStyle(
                                    fontSize: 17.sp,
                                    height: 1.0,
                                    color: context.theme.colorScheme.secondary
                                ))
                              ]),
                          //  color: BaseColor.blue300,
                        )),
                  ],
                )

              ],
            )),
        // divider,
        SizedBox(height: 8.sp),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 17.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateParser.formatLocaleYmd(element.ymd),
                style: TextStyle(
                    color: context.theme.colorScheme.secondary,
                    fontSize: diaryFontSize * 1.2,
                    fontFamily: diaryFont),
              ),
              element.imageUrl != null ? GestureDetector(
                  onTap: () => imagePreviewDialog(element.imageUrl!),
                  child:Padding(padding: EdgeInsets.symmetric(),
                      child: Center(child: Container(
                        width:  width * 0.9,
                        height: width * 0.5,
                        decoration: BoxDecoration(
                          color: BaseColor.defaultBackgroundColor,
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(element.imageUrl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))
                  )) : Container(),
              Text(
                element.content,
                style: TextStyle(
                    color: context.theme.colorScheme.secondary,
                    fontSize: diaryFontSize,
                    fontFamily: diaryFont),
              ),
              element.commentCount != 0 ? Column(
                children: [
                  SizedBox(height: 16.sp),
                  TouchableOpacity(
                      onTap: () => onTapComment?.let((it) => it(element)),
                      child: Text(
                        message('generic_tap_to_see_comment').format([element.commentCount]),
                      ))

                ],
              ): Container()

            ],
          ),
        ),
        SizedBox(
          height: 5.sp,
        ),
      ],
    );
  }
  Widget friendProfileIcon(Color color, String? url) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 36.sp,
          height: 36.sp,
          decoration: BoxDecoration(
            color: BaseColor.defaultBackgroundColor,
            shape: BoxShape.circle,
            image: url != null
                ? DecorationImage(
              image: CachedNetworkImageProvider(url),
              fit: BoxFit.cover,
            )
                : null,
          ),
        ),
        Container(
          width: 44.sp,
          height: 44.sp,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3.0),
          ),
        )
      ],
    );
  }


}
