import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:magcloud_app/core/model/feed_element.dart';
import 'package:magcloud_app/core/service/tag_resolver.dart';
import 'package:magcloud_app/core/util/extension.dart';
import 'package:magcloud_app/core/util/hash_util.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/global_routes.dart';
import 'package:magcloud_app/view/component/profile_image_icon_with_mood.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';

import '../../core/model/mood.dart';
import '../../core/util/date_parser.dart';
import '../../core/util/font.dart';
import '../../core/util/i18n.dart';
import '../designsystem/base_color.dart';
import '../dialog/image_preview_dialog.dart';

class FeedElementView extends StatefulWidget {
  FeedElement element;
  double width;
  void Function(FeedElement element)? onTapProfileImage;
  void Function(FeedElement element)? onTapLike;
  void Function(FeedElement element)? onTapUnlike;
  void Function(FeedElement element)? onTapComment;


  FeedElementView(this.element, this.width, {super.key, this.onTapProfileImage, this.onTapLike, this.onTapUnlike, this.onTapComment});

  @override
  State<StatefulWidget> createState() => _FeedElementViewState();

}

class _FeedElementViewState extends State<FeedElementView> {
  List<TextSpan> texts = List.empty(growable: true);
  _FeedElementViewState() {
    ////texts.add(TextSpan(text: widget.element.content));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      loadTag();
    });
  }

  Future<void> loadTag() async {
    final result = await parseContent(context.theme.colorScheme, widget.element.content);
    setState(() {
      texts = result;
    });
  }


  @override
  Widget build(BuildContext context) {
    final divider = Divider(color: context.theme.colorScheme.outline, thickness: 1.sp);
    return Column(
      key: Key(widget.element.diaryId),
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
                        onTap: () => widget.onTapProfileImage?.let((it) => it(widget.element)),
                        child: ProfileImageIconWithMood(
                            baseSize: 36,
                            mood: widget.element.mood,
                            url: widget.element.profileImageUrl)),
                    SizedBox(width: 8.sp),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.element.userName,
                          style: TextStyle(
                              color: context.theme.colorScheme.primary,
                              fontSize: 14.sp,
                              height: 1.3,
                              fontFamily: 'Pretendard'),
                        ),
                        Text(
                          message('generic_created_before').format(
                              [DateParser.gapBetweenNow(widget.element.createdAt)]),
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
                        onTap: widget.element.isLiked ? () => widget.onTapUnlike?.let((it) => it(widget.element)) : () => widget.onTapLike?.let((it) => it(widget.element)),
                        child: Container(
                          //  width: 33.sp,
                          height: 33.sp,
                          //color: Colors.blueAccent,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Icon(Icons.calendar_today_outlined, size: 18.sp, color: BaseColor.warmGray400),
                                widget.element.isLiked ? Icon(CupertinoIcons.suit_heart_fill,
                                    size: 18.sp, color: BaseColor.red400) : Icon(CupertinoIcons.suit_heart,
                                    size: 18.sp, color: BaseColor.red400),
                                SizedBox(width: 3.sp),
                                Text(widget.element.likeCount.toString(), style: TextStyle(
                                    fontSize: 17.sp,
                                    height: 1.0,
                                    color: context.theme.colorScheme.secondary
                                ))
                              ]),
                          //  color: BaseColor.blue300,
                        )),
                    SizedBox(width: 10.sp),
                    TouchableOpacity(
                        onTap: () => widget.onTapComment?.let((it) => it(widget.element)),
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
                                Text(widget.element.commentCount.toString(), style: TextStyle(
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
                "${DateParser.formatLocaleYmd(widget.element.ymd)}, ${widget.element.mood.getLocalizedName()}",
                style: TextStyle(
                    color: context.theme.colorScheme.secondary,
                    fontSize: diaryFontSize * 1.2,
                    fontFamily: diaryFont),
              ),
              widget.element.imageUrl != null ? GestureDetector(
                  onTap: () => imagePreviewDialog(widget.element.imageUrl!),
                  child:Padding(padding: EdgeInsets.symmetric(),
                      child: Center(child: Container(
                        width:  widget.width * 0.9,
                        height: widget.width * 0.5,
                        decoration: BoxDecoration(
                          color: BaseColor.defaultBackgroundColor,
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(widget.element.imageUrl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))
                  )) : Container(),
              RichText(
                key: Key(widget.element.diaryId),
              text: texts.isEmpty ? TextSpan(
               text: widget.element.content,
                  style: TextStyle(
                      color: context.theme.colorScheme.secondary,
                      fontSize: diaryFontSize,
                      fontFamily: diaryFont)
              ) : TextSpan(
              children: texts
              )),
              widget.element.commentCount != 0 ? Column(
                children: [
                  SizedBox(height: 16.sp),
                  TouchableOpacity(
                      onTap: () => widget.onTapComment?.let((it) => it(widget.element)),
                      child: Text(
                        message('generic_tap_to_see_comment').format([widget.element.commentCount]),
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

  Future<List<TextSpan>> parseContent(ColorScheme colors, String content) async {
    final result = toParsedString(content);
    return await Future.wait(result.map((content) async {
      if(content.startsWith("@")) {
        final id = content.substring(1);
        if(HashUtil.isULID(id)){
          final user = await inject<TagResolver>().getByUserId(id);
          if( user != null ) {
            return TextSpan(
                recognizer: TapGestureRecognizer()..onTap = () => GlobalRoute.friendProfileView(user.userId),
                text: user.name,
                style: TextStyle(
                    color: BaseColor.green300,
                    fontSize: diaryFontSize,
                    fontFamily: diaryFont
                ));
          }
        }
      } else if(content.startsWith("#")) {
        return TextSpan(text: content, style: TextStyle(
            color: BaseColor.blue300,
            fontSize: diaryFontSize,
            fontFamily: diaryFont
        ));
      }
      return TextSpan(text: content, style: TextStyle(
          color: colors.secondary,
          fontSize: diaryFontSize,
          fontFamily: diaryFont
      ));
    }));
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
