import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:magcloud_app/core/framework/base_child_view.dart';
import 'package:magcloud_app/core/model/user.dart';
import 'package:magcloud_app/core/util/date_parser.dart';
import 'package:magcloud_app/core/util/font.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';
import 'package:magcloud_app/view/designsystem/base_icon.dart';

import '../../../view_model/calendar_view/calendar_base_view_model.dart';
import '../../../view_model/calendar_view/calendar_base_view_state.dart';
import '../../../view_model/calendar_view/calendar_scope_data_state.dart';
import 'calendar_base_view.dart';

class CalendarDailyDiaryView extends BaseChildView<CalendarBaseView,
    CalendarBaseViewModel, CalendarBaseViewState> {
  CalendarDailyDiaryView({super.key});

  @override
  Widget render(BuildContext context, CalendarBaseViewModel action,
      CalendarBaseViewState state) {
    //final diary = state.currentDiary!;
    final width = MediaQuery.of(context).size.width;
    double getAnimationOffset() {
      if (action.animationStart) {
        action.animationStart = false;
        return action.forwardAction ? -0.8 : 0.8;
      } else {
        return action.forwardAction ? 0.8 : -0.8;
      }
    }

    final scopeData = state.scopeData as CalendarDailyViewScopeData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        dailyViewTopBar(context, action, state),
        scopeData.imageUrl != null
            ? Padding(
                padding: EdgeInsets.symmetric(),
                child: Center(
                    child: Stack(
                  children: [
                    Center(child: Container(
                      width: width * 0.9,
                      height: width * 0.5,
                      decoration: BoxDecoration(
                        color: BaseColor.defaultBackgroundColor,
                        image: DecorationImage(
                          image:
                              CachedNetworkImageProvider(scopeData.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
                    scopeData.isMyScope
                        ? Positioned(
                        top: 10.sp,
                        right: 30.sp,
                        child:TouchableOpacity(
                            onTap: action.onTapRemoveImage,
                            child:  Opacity(
                                    opacity: 0.8,
                                    child: Container(
                                        width: 30.sp,
                                        height: 30.sp,
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text('X',
                                                style: TextStyle(
                                                    color: BaseColor
                                                        .defaultBackgroundColor,
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'GmarketSans'))),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: BaseColor.warmGray800,
                                        )))))
                        : Container()
                  ],
                )))
            : Container(),
        Expanded(
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(getAnimationOffset(), 0.0),
                        // adjust the position as you need
                        end: const Offset(0.0, 0.0),
                      ).animate(animation),
                      child: child);
                },
                child: Column(
                  key: Key(state.currentDate.day.toString()),
                  children: [
                    // dailyDiaryMoodBox(action, scopeData),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: Listener(
                          onPointerMove: action.onTextFieldMove,
                          child: TextField(
                            onChanged: (e) => action.onEditingCompleted(),
                            onTapOutside: (e) => action.unFocusTextField(),
                            readOnly: !scopeData.isMyScope || !action.isDiaryWriteable(),
                            focusNode: scopeData.focusNode,
                            style: TextStyle(
                              fontFamily: diaryFont,
                              fontSize: diaryFontSize,
                                color: context.theme.colorScheme.secondary
                            ),
                            controller: scopeData.diaryTextController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: scopeData.isMyScope
                                    ? message('message_tap_here_to_diary')
                                    : message('message_diary_is_empty'),
                                hintStyle:
                                    TextStyle(color: context.theme.colorScheme.secondary)),
                          )),
                    )),
                    Divider(color: context.theme.colorScheme.outline),
                    Padding(
                      padding: EdgeInsets.only(right: 8.sp, bottom: 6.sp, left: 8.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          scopeData.getTagSelectionText() != null ? Expanded(child: friendPreviewList(context, action, scopeData.getTagSelectionText()!)) : Container(),
                          Row(children: [
                            SizedBox(width: 5.sp),
                            state.scopeData.isMyScope ? imageAddBox(action,
                                state.scopeData as CalendarDailyViewScopeData) : Container(),
                            SizedBox(width: 5.sp),
                            dailyDiaryMoodBox(action,
                                state.scopeData as CalendarDailyViewScopeData)
                          ]),

                        ],
                      ),
                    )
                  ],
                )))
      ],
    );
  }

  Widget friendPreview(BuildContext context,CalendarBaseViewModel action, User friend) {
    return TouchableOpacity(
      onTap: () => action.onTapApplyFriendTag(friend),
        child: Row(children: [Container(
      decoration: BoxDecoration(
          color: context.theme.colorScheme.onBackground,
          borderRadius: BorderRadius.circular(10.sp)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 3.sp),
            child: Row(
      children: [
        Text(friend.name, style: TextStyle(
            color: context.theme.colorScheme.secondary,
            fontSize: 14.sp,
            fontFamily: 'GmarketSans')),

      ],
    ))),
      SizedBox(width: 5.sp)
    ]));

  }

  Widget friendPreviewList(BuildContext context, CalendarBaseViewModel action, String currentText) {
    final matches = action.findFriendMatches(currentText);
    final preview =  matches.map((e) => friendPreview(context, action, e)).toList();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  // fit: StackFit.expand,
                  children: [
                    Container(
                      color: context.theme.colorScheme.background,
                      width: double.infinity,
                      height: 26.sp,
                      child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          slivers: [
                            preview.isNotEmpty ?
                            SliverList(
                                delegate: SliverChildListDelegate(preview)) : SliverToBoxAdapter(
                              child: Text(
                                message('message_cannot_find_taggable_user'),
                                style: TextStyle(
                                    color: context.theme.colorScheme.primary,
                                    fontSize: 14.sp,
                                    fontFamily: 'GmarketSans'),
                              ),
                            ),

                          ]),
                    ),
                  ],
                ))
          ],
        );
  }

  Widget dailyViewTopBar(
      BuildContext context,
      CalendarBaseViewModel action, CalendarBaseViewState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TouchableOpacity(
              onTap: action.onTapDayTitle,
              child: Text(
                DateParser.formatLocaleYmd(state.currentDate),
                style: TextStyle(
                    color: context.theme.colorScheme.primary,
                    fontSize: 16.sp,
                    fontFamily: 'GmarketSans'),
              )),
          Row(
            children: [
              TouchableOpacity(
                  onTap: () => action.changeDay(-1),
                  child: Icon(BaseIcon.arrowLeft, color: context.theme.colorScheme.secondary)),
              TouchableOpacity(
                  onTap: () => action.changeDay(1),
                  child: Icon(BaseIcon.arrowRight, color: context.theme.colorScheme.secondary)),
            ],
          )
        ],
      ),
    );
  }

  Widget dailyDiaryMoodBox(
      CalendarBaseViewModel action, CalendarDailyViewScopeData data) {
    return TouchableOpacity(
        onTap: data.isMyScope ? action.onTapChangeMood : null,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.sp, vertical: 0.sp),
          child: Container(
            decoration: BoxDecoration(
              // border: Border.all(color: BaseColor.warmGray300),
              borderRadius: BorderRadius.circular(10),
              color: data.currentMood.moodColor,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 7.sp),
              child: Center(
                child: Text(
                  data.currentMood.getLocalizedName(),
                  style: TextStyle(
                    color: BaseColor.warmGray600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget imageAddBox(
      CalendarBaseViewModel action, CalendarDailyViewScopeData data) {
    return TouchableOpacity(
        onTap: action.isDiaryWriteable() ? action.uploadImage : null,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.sp, vertical: 0.sp),
          child: Container(
            decoration: BoxDecoration(
              // border: Border.all(color: BaseColor.warmGray300),
              borderRadius: BorderRadius.circular(10),
              color: BaseColor.green300,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: 3.sp, bottom: 3.sp, left: 8.sp, right: 9.sp),
              child: Center(
                child: Icon(Icons.add_a_photo,
                    color: BaseColor.warmGray500, size: 20.sp),
              ),
            ),
          ),
        ));
  }
}
