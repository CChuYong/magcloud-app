import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:magcloud_app/core/api/dto/diary/diary_comment_request.dart';
import 'package:magcloud_app/core/api/open_api.dart';
import 'package:magcloud_app/core/model/feed_element.dart';
import 'package:magcloud_app/core/util/extension.dart';
import 'package:magcloud_app/di.dart';

import '../../core/api/dto/diary/diary_comment_response.dart';
import '../../core/util/date_parser.dart';
import '../../core/util/i18n.dart';
import '../../global_routes.dart';
import '../component/touchableopacity.dart';
import '../designsystem/base_color.dart';

Future<void> openCommentListDialog(String diaryId, List<DiaryCommentResponse> comments) {
  final textController = TextEditingController();
  final focusNode = FocusNode();
  final context = Get.context!;
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
      backgroundColor: context.theme.colorScheme.onBackground,
      insetPadding: null,
      alignment: Alignment.bottomCenter,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      child: Builder(
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          return StatefulBuilder(
              builder: (ctx, setState) => SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    height: height * 0.85,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 22.sp),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 18.sp),
                                Text(message('generic_comment_page_title').format([comments.length]),
                                    style: TextStyle(
                                      color: context.theme.colorScheme.primary,
                                      fontSize: 16.sp,
                                    )),
                                TouchableOpacity(
                                  onTap: () => GlobalRoute.back(),
                                  child: Icon(CupertinoIcons.xmark, size: 18.sp, color: BaseColor.warmGray500))
                                ,
                              ],
                            ),
                            SizedBox(height: 16.sp),
                            Expanded(
                              child: RefreshIndicator(
                                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                                onRefresh: () async {} ,
                                child: CustomScrollView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    reverse: false,
                                    slivers: [
                                      SliverList(
                                          delegate: SliverChildListDelegate(comments.map((e) => friendBox(context, e)).toList())),
                                      SliverToBoxAdapter(child: SizedBox(height: 8.sp)),
                                    ]),
                              ),
                            ),
                            Stack(
                                alignment: Alignment.center,
                                children: [
                              TextField(
                                controller: textController,
                                decoration: InputDecoration(
                                    hintText:
                                    message('generic_add_comment_to_diary'),
                                    hintStyle: TextStyle(
                                        color: context.theme.colorScheme.secondary,
                                        fontSize: 12.sp),
                                    contentPadding:
                                    EdgeInsets.fromLTRB(15.sp, 0.sp, 5.sp, 0.sp),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24.sp),
                                        borderSide: BorderSide(
                                          color: BaseColor.warmGray200,
                                          width: 1.sp,
                                        ))),
                                style:
                                TextStyle(color: context.theme.colorScheme.secondary, fontSize: 12.sp),
                              ),
                              Positioned(right: 12.sp,child:
                                  TouchableOpacity(
                                    onTap: () async {
                                      final text = textController.text;
                                      textController.text = '';
                                      final openAPI = inject<OpenAPI>();
                                      await openAPI.createDiaryComments(diaryId, DiaryCommentRequest(content: text));
                                      final queriedComments = await openAPI.getDiaryComments(diaryId);
                                      setState(() {
                                        comments = queriedComments;
                                      });
                                    },
                                    child: Icon(CupertinoIcons.paperplane_fill, color: context.theme.colorScheme.secondary),
                                  )
                              )

                            ]),
                          ],
                        )),
                  )));
        },
      ),
    ),
  );
}

Widget friendBox(BuildContext context, DiaryCommentResponse response) {
  return Column(
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          TouchableOpacity(
             // onTap: () => action.onTapFriend(friend),
              child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        width: 38.sp,
                        height: 38.sp,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  response.profileImageUrl),
                              fit: BoxFit.cover,
                            ),
                            color: BaseColor.warmGray700,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: BaseColor.warmGray300, width: 0.5)),
                      ),
                      SizedBox(width: 10.sp),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(
                            response.username,
                            style: TextStyle(
                              color: context.theme.colorScheme.primary,
                              fontSize: 14.sp,
                            ),
                          ),
                            SizedBox(width: 4.sp),
                            Text(
                              "${DateParser.gapBetweenNow(response.createdAtTs)} ${message('generic_before')}",
                              style: TextStyle(
                                color: context.theme.colorScheme.secondary,
                                fontSize: 10.sp,
                              ),
                            ),
                          ]),
                          Text(
                            response.content,
                            style: TextStyle(
                              color: context.theme.colorScheme.secondary,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ))),
        ],
      ),
      SizedBox(height: 10.sp),
    ],
  );
}
