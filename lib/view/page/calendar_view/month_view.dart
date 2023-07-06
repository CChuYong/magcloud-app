import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/core/framework/base_child_view.dart';
import 'package:magcloud_app/core/util/date_parser.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';
import 'package:magcloud_app/view/designsystem/base_icon.dart';
import 'package:magcloud_app/view_model/calendar_view/calendar_scope_data_state.dart';

import '../../../core/util/i18n.dart';
import '../../../view_model/calendar_view/calendar_base_view_model.dart';
import '../../../view_model/calendar_view/calendar_base_view_state.dart';
import 'calendar_base_view.dart';

class CalendarMonthView extends BaseChildView<CalendarBaseView,
    CalendarBaseViewModel, CalendarBaseViewState> {
  CalendarMonthView({super.key});

  final horizontalPaddingSize = 23.sp;
  final boxGap = 5.sp;
  final dayOfWeekFontSize = 18.sp;

  double getAnimationOffset() {
    if (action.animationStart) {
      action.animationStart = false;
      return action.forwardAction ? -0.8 : 0.8;
    } else {
      return action.forwardAction ? 0.8 : -0.8;
    }
  }

  @override
  Widget render(BuildContext context, CalendarBaseViewModel action,
      CalendarBaseViewState state) {
    final fullWidth = MediaQuery.of(context).size.width;
    final boxWidth = (fullWidth - horizontalPaddingSize * 2 - boxGap * 6) / 7;
    final scopeData = state.scopeData as CalendarMonthViewScopeData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        monthViewTopBar(action, state),
        SizedBox(height: 20.sp),
        AnimatedSwitcher(
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
          child: Padding(
            key: Key(state.currentMonth.toString()),
            padding: EdgeInsets.symmetric(horizontal: horizontalPaddingSize),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: boxWidth / 2 - (dayOfWeekFontSize / 2)),
                  child: dayOfWeekTitle(),
                ),
                SizedBox(height: 10.sp),
                drawCalendar(action, state, boxWidth: boxWidth, boxGap: boxGap),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget monthViewTopBar(
      CalendarBaseViewModel action, CalendarBaseViewState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TouchableOpacity(
              onTap: action.onTapMonthTitle,
              child: Text(
                DateParser.formatLocaleYm(state.currentYear, state.currentMonth),
                style: TextStyle(
                  color: BaseColor.warmGray600,
                  fontSize: 16.sp,
                ),
              )),
          Row(
            children: [
              TouchableOpacity(
                  onTap: () => action.changeMonth(-1),
                  child: const Icon(BaseIcon.arrowLeft)),
              TouchableOpacity(
                  onTap: () => action.changeMonth(1),
                  child: const Icon(BaseIcon.arrowRight)),
            ],
          )
        ],
      ),
    );
  }

  Widget drawCalendar(CalendarBaseViewModel action, CalendarBaseViewState state,
      {required double boxWidth, required double boxGap}) {
    final monthGrid = state.getMonthGrid();
    return Column(children: [
      for (List<int> week in monthGrid) ...[
        Row(
          children: [
            for (int dayOfWeek = 0; dayOfWeek < week.length; dayOfWeek++) ...[
              week[dayOfWeek] == -1
                  ? SizedBox(width: boxWidth, height: boxWidth)
                  : createDayBox(action,
                      day: week[dayOfWeek], boxWidth: boxWidth),
              if (dayOfWeek != week.length - 1) SizedBox(width: boxGap)
            ]
          ],
        ),
        SizedBox(height: boxGap),
      ]
    ]);
  }

  Widget createDayBox(CalendarBaseViewModel action,
      {required int day, required double boxWidth}) {
    final scopeData = action.state.scopeData as CalendarMonthViewScopeData;
    return TouchableOpacity(
        onTap: () => day > 0 ? action.onTapDayBox(day) : (day == -1 ? null : action.snackNoFuture()),
        child: Container(
          width: boxWidth,
          height: boxWidth,
          decoration: BoxDecoration(
              border: Border.all(color: BaseColor.warmGray300),
              borderRadius: BorderRadius.circular(15),
              color: scopeData.dailyMood[day]?.moodColor),
          child: Center(
            child: Text(
              day.abs().toString(),
              style: TextStyle(
                color: day > 0 ? BaseColor.warmGray500 : BaseColor.warmGray300,
                fontSize: 18.sp,
              ),
            ),
          ),
        ));
  }

  Widget dayOfWeekTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          message("generic_simple_sunday"),
          style: TextStyle(
            color: BaseColor.red400,
            fontSize: dayOfWeekFontSize,
          ),
        ),
        Text(
          message("generic_simple_monday"),
          style: TextStyle(
            color: BaseColor.warmGray600,
            fontSize: dayOfWeekFontSize,
          ),
        ),
        Text(
          message("generic_simple_tuesday"),
          style: TextStyle(
            color: BaseColor.warmGray600,
            fontSize: dayOfWeekFontSize,
          ),
        ),
        Text(
          message("generic_simple_wednesday"),
          style: TextStyle(
            color: BaseColor.warmGray600,
            fontSize: dayOfWeekFontSize,
          ),
        ),
        Text(
          message("generic_simple_thursday"),
          style: TextStyle(
            color: BaseColor.warmGray600,
            fontSize: dayOfWeekFontSize,
          ),
        ),
        Text(
          message("generic_simple_friday"),
          style: TextStyle(
            color: BaseColor.warmGray600,
            fontSize: dayOfWeekFontSize,
          ),
        ),
        Text(
          message("generic_simple_saturday"),
          style: TextStyle(
            color: BaseColor.green400,
            fontSize: dayOfWeekFontSize,
          ),
        ),
      ],
    );
  }
}
