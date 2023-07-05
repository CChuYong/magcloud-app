import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/core/framework/base_child_view.dart';
import 'package:magcloud_app/core/model/diary.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';
import 'package:magcloud_app/view/designsystem/base_icon.dart';

import '../../../core/util/i18n.dart';
import '../../../view_model/calendar_view/calendar_base_view_model.dart';
import '../../../view_model/calendar_view/calendar_base_view_state.dart';
import '../../../view_model/calendar_view/calendar_scope_data_state.dart';
import '../../component/navigation_bar.dart';
import 'calendar_base_view.dart';

class CalendarDailyDiaryView extends BaseChildView<CalendarBaseView, CalendarBaseViewModel, CalendarBaseViewState> {
  CalendarDailyDiaryView({super.key});

  @override
  Widget render(BuildContext context, CalendarBaseViewModel action, CalendarBaseViewState state) {
    //final diary = state.currentDiary!;
    final scopeData = state.scopeData as CalendarDailyViewScopeData;
    return Scaffold(
      backgroundColor: BaseColor.defaultBackgroundColor,
      bottomNavigationBar: BaseNavigationBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dailyViewTopBar(action, state),
            dailyDiaryMoodBox(scopeData),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: TextField(
                    style: TextStyle(
                      fontFamily: "KyoboHandWriting",
                      fontSize: 16.sp,
                    ),
                    controller: scopeData.diaryTextController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                )

            )
          ],
        ),
      ),
    );
  }

  Widget dailyViewTopBar(CalendarBaseViewModel action, CalendarBaseViewState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TouchableOpacity(onTap: () => action.changeDay(-1), child: const Icon(BaseIcon.arrowLeft)),
          TouchableOpacity(
            onTap: action.onTapDayTitle,
              child: Text(
            '${state.currentYear}${message("generic_year")} ${state.currentMonth}${message("generic_month")} ${state.currentDay}${message("generic_day")}',
            style: TextStyle(
              color: BaseColor.warmGray600,
              fontSize: 16.sp,
            ),
            )
          )
          ,
          TouchableOpacity(onTap: () => action.changeDay(1), child: const Icon(BaseIcon.arrowRight)),
        ],
      ),
    );
  }

  Widget dailyDiaryMoodBox(CalendarDailyViewScopeData data) {
    final Diary diary = data.currentDiary;
    return TouchableOpacity(
        onTap: () => {},
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 5.sp),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: BaseColor.warmGray300),
              borderRadius: BorderRadius.circular(15),
              color: diary.mood.moodColor,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 13.sp),
              child: Center(
                child: Text(
                  diary.mood.localizedName,
                  style: TextStyle(
                    color:  BaseColor.warmGray500,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
        ));
  }


}
