import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:magcloud_app/core/api/dto/diary/diary_comment_request.dart';
import 'package:magcloud_app/core/api/open_api.dart';
import 'package:magcloud_app/core/model/feed_element.dart';
import 'package:magcloud_app/core/service/auth_service.dart';
import 'package:magcloud_app/core/util/extension.dart';
import 'package:magcloud_app/core/util/snack_bar_util.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/view/dialog/confirm_dialog.dart';

import '../../core/api/dto/diary/diary_comment_response.dart';
import '../../core/model/user.dart';
import '../../core/service/tag_resolver.dart';
import '../../core/util/date_parser.dart';
import '../../core/util/hash_util.dart';
import '../../core/util/i18n.dart';
import '../../global_routes.dart';
import '../component/taggable_text_editing_controller.dart';
import '../component/touchableopacity.dart';
import '../designsystem/base_color.dart';
import '../page/profile_view.dart';

Future<Object?> openCommentListDialog(
    String diaryId, List<DiaryCommentResponse> comments) async {
  final textController = TaggableTextEditingController();
  late void Function(void Function()) gSetState;
  int? tagSelectionStart = null;
  int? tagSelectionEnd = null;

  String? getTagSelectionText() {
    if(tagSelectionStart != null && tagSelectionEnd != null){
      return textController.text.substring(tagSelectionStart!, tagSelectionEnd!);
    }
    return null;

  }

  textController.addListener(() {
    final _controller = textController;
    final currentTextBlock = _controller.text;
    int startBlockPosition = _controller.selection.baseOffset - 1;
    int endBlockPosition = _controller.selection.baseOffset - 1;
    if(startBlockPosition < 0 || endBlockPosition < 0) return;
    int maxCursorPosition = currentTextBlock.length;
    String currentChar = '';
    while(startBlockPosition > 0 && (currentChar = currentTextBlock[startBlockPosition - 1]) != ' ' && currentChar != '\n') {
      startBlockPosition--;
    }
    while(endBlockPosition >= 0 && endBlockPosition < maxCursorPosition - 1 && (currentChar = currentTextBlock[endBlockPosition + 1]) != ' ' && currentChar != '\n') {
      endBlockPosition++;
    }
    final block = currentTextBlock.substring(startBlockPosition, endBlockPosition + 1);
    if(block.startsWith("@")) {
      gSetState(() {
        tagSelectionStart = startBlockPosition+1;
        tagSelectionEnd = endBlockPosition + 1;
      });
    }else {
      if(tagSelectionStart != null) {
        gSetState(() {
          tagSelectionStart = null;
          tagSelectionEnd = null;
        });
      }
    }
  });
  final FocusNode focusNode = FocusNode();
  final context = Get.context!;
  final Map<String, List<TextSpan>> spanMap = {};
  updateSpanMap() async {
    await Future.wait(comments.map((element) async {
      final k =  await parseContent(element.content, TextStyle(
        color: context.theme.colorScheme.primary,
        fontSize: 12.sp,
      ));
      spanMap[element.commentId] = k;
    }));
  }
  await updateSpanMap();


  return await showGeneralDialog(
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
      pageBuilder: (_, _1, _2) => Dismissible(
            key: Key("comment_list"),
            direction: DismissDirection.vertical,
            onDismissed: (_) {
              Navigator.of(context).pop();
            },
            child: Dialog(
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
                      builder: (ctx, setState) {
                        gSetState = setState;
                        return SafeArea(
                          top: false,
                          child: SizedBox(
                            width: double.infinity,
                            height: height * 0.85,
                            child: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 20.sp),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 11.sp),
                                    Container(
                                      height: 5.sp,
                                      width: 40.sp,
                                      decoration: BoxDecoration(
                                        color: BaseColor.warmGray500,
                                        borderRadius:
                                            BorderRadius.circular(2.sp),
                                      ),
                                    ),
                                    SizedBox(height: 10.sp),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            message('generic_comment_page_title')
                                                .format([comments.length]),
                                            style: TextStyle(
                                              color: context
                                                  .theme.colorScheme.primary,
                                              fontSize: 16.sp,
                                            )),
                                      ],
                                    ),
                                    SizedBox(height: 8.sp),
                                    Divider(
                                        color:
                                            context.theme.colorScheme.outline),
                                    SizedBox(height: 8.sp),
                                    Expanded(
                                      child: RefreshIndicator(
                                        triggerMode:
                                            RefreshIndicatorTriggerMode.onEdge,
                                        onRefresh: () async {},
                                        child: CustomScrollView(
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            reverse: false,
                                            slivers: [
                                              SliverList(
                                                  delegate:
                                                      SliverChildListDelegate(
                                                          comments
                                                              .map((e) =>
                                                                  friendBox(
                                                                      context,
                                                                      e,
                                                                  () async {
                                                                final openAPI =
                                                                    inject<
                                                                        OpenAPI>();
                                                                final queriedComments =
                                                                    await openAPI
                                                                        .getDiaryComments(
                                                                            diaryId);
                                                                comments =
                                                                    queriedComments;
                                                                await updateSpanMap();
                                                                setState(() {});
                                                              }, spanMap[e.commentId]!))
                                                              .toList())),
                                              SliverToBoxAdapter(
                                                  child:
                                                      SizedBox(height: 8.sp)),
                                            ]),
                                      ),
                                    ),
                                    getTagSelectionText() != null ?
                                        Column(
                                          children: [
                                            friendPreviewList(context, getTagSelectionText()!, (user) {
                                              if(tagSelectionStart == null || tagSelectionEnd == null) return;
                                              setState(() {
                                                textController.addUser(user);
                                                final updatedText = replaceSubstringInRange(textController.text, "${user.userId} ", tagSelectionStart!, tagSelectionEnd!);
                                                tagSelectionStart = null;
                                                tagSelectionEnd = null;
                                                textController.text = updatedText;
                                              });
                                            }),
                                            SizedBox(height: 10.sp)
                                          ],
                                        ) : Container(),
                                    Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          TextField(
                                            controller: textController,
                                            focusNode: focusNode,
                                            onTapOutside: (e) {
                                              focusNode.unfocus();
                                            },
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: context.theme.colorScheme.background,
                                                hintText: message(
                                                    'generic_add_comment_to_diary'),
                                                hintStyle: TextStyle(
                                                    color: context.theme
                                                        .colorScheme.secondary,
                                                    fontSize: 12.sp),
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(15.sp,
                                                        0.sp, 5.sp, 0.sp),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24.sp),
                                                    borderSide: BorderSide(
                                                      color:
                                                          BaseColor.warmGray200,
                                                      width: 1.sp,
                                                    ))),
                                            style: TextStyle(
                                                color: context.theme.colorScheme
                                                    .secondary,
                                                fontSize: 12.sp),
                                          ),
                                          Positioned(
                                              right: 12.sp,
                                              child: TouchableOpacity(
                                                onTap: () async {
                                                  final text =
                                                      textController.text;
                                                  textController.text = '';
                                                  final openAPI =
                                                      inject<OpenAPI>();
                                                  await openAPI
                                                      .createDiaryComments(
                                                          diaryId,
                                                          DiaryCommentRequest(
                                                              content: text));
                                                  final queriedComments =
                                                      await openAPI
                                                          .getDiaryComments(
                                                              diaryId);
                                                  comments = queriedComments;
                                                  await updateSpanMap();
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                    CupertinoIcons
                                                        .paperplane_fill,
                                                    color: context.theme
                                                        .colorScheme.secondary),
                                              ))
                                        ]),
                                  ],
                                )),
                          ));});
                },
              ),
            ),
          ));
}

Widget friendBox(BuildContext context, DiaryCommentResponse response,
    void Function() updateComments, List<TextSpan> spans) {
  final isMyComment =
      response.userId == inject<AuthService>().initialUser?.userId;
  return Column(
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  TouchableOpacity(
                      onTap: () {
                        Get.back();
                        onTapProfileImage(response.userId);
                      },
                      child: Container(
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
                      )),
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
                        isMyComment
                            ? Row(
                                children: [
                                  SizedBox(width: 4.sp),
                                  TouchableOpacity(
                                      onTap: () => onTapDelete(response.diaryId,
                                                  response.commentId)
                                              .then((value) {
                                            if (value) updateComments();
                                          }),
                                      child: Text(
                                        message('generic_friend_delete'),
                                        style: TextStyle(
                                          color: BaseColor.red300,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.sp,
                                        ),
                                      )),
                                ],
                              )
                            : Container(),
                      ]),
                      RichText(text: TextSpan(
                        children: spans
                      )),
                    ],
                  ),
                ],
              )),
        ],
      ),
      SizedBox(height: 10.sp),
    ],
  );
}

void onTapProfileImage(String userId) async {
  final user = await inject<OpenAPI>().getUserProfile(userId);
  route() => ProfileView(user.toDomain(),
      inject<AuthService>().initialUser?.userId == userId, true);
  GlobalRoute.rightToLeftRouteToDynamic(route);
}

Future<bool> onTapDelete(String diaryId, String commentId) async {
  final res = await confirmDialog(
      message('message_delete_comment'), message('message_delete_comment_info'),
      confirmText: message('generic_delete'));
  if (!res) return false;
  final openAPI = inject<OpenAPI>();

  final response = await openAPI.deleteComment(diaryId, commentId);
  SnackBarUtil.infoSnackBar(message: response.message);
  return response.success;
}

Future<List<TextSpan>> parseContent(
    String content, TextStyle genericStyle) async {
  final result = toParsedString(content);
  return await Future.wait(result.map((content) async {
    if (content.startsWith("@")) {
      final id = content.substring(1);
      if (HashUtil.isULID(id)) {
        final user = await inject<TagResolver>().getByUserId(id);
        if (user != null) {
          return TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => GlobalRoute.friendProfileView(user.userId),
              text: user.name,
              style: genericStyle.copyWith(
                color: BaseColor.green300,
              ));
        }
      }
    } else if (content.startsWith("#")) {
      return TextSpan(
          text: content,
          style: genericStyle.copyWith(
            color: BaseColor.blue300,
          ));
    }
    return TextSpan(text: content, style: genericStyle);
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

Widget friendPreview(BuildContext context, User friend, void Function(User) onTapFriend) {

  return TouchableOpacity(
      onTap: () => onTapFriend(friend),
      child: Row(children: [Container(
          decoration: BoxDecoration(
              color: context.theme.colorScheme.background,
              borderRadius: BorderRadius.circular(10.sp)),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 3.sp),
              child: Row(
                children: [
                  Text(friend.name, style: TextStyle(
                      color: context.theme.colorScheme.primary,
                      fontSize: 14.sp,
                      fontFamily: 'GmarketSans')),

                ],
              ))),
        SizedBox(width: 5.sp)
      ]));

}

Widget friendPreviewList(BuildContext context,  String currentText, void Function(User) onTapFriend) {
  final matches = findFriendMatches(currentText);
  return Row(
    children: [
      Expanded(
          child: Stack(
            alignment: Alignment.center,
            // fit: StackFit.expand,
            children: [
              Container(
                width: double.infinity,
                height: 26.sp,
                child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    slivers: [
                      SliverList(
                          delegate: SliverChildListDelegate(
                              matches.map((e) => friendPreview(context, e, onTapFriend)).toList())),

                    ]),
              ),
            ],
          ))
    ],
  );
}


List<User> findFriendMatches(String text) {
  final matches = inject<TagResolver>().friendCache.values.toList().where((element) => element.nameTag.contains(text)).toList();
  return matches.sublist(0, min(8, matches.length));
}

String replaceSubstringInRange(String originalString, String replacement, int startIndex, int endIndex) {
  if (startIndex < 0 || endIndex > originalString.length) {
    throw ArgumentError("startIndex and endIndex must be within the range of the original string.");
  }

  String firstPart = originalString.substring(0, startIndex);
  String lastPart = originalString.substring(endIndex);

  return "$firstPart$replacement$lastPart";
}
