import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/core/framework/base_child_view.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';
import 'package:magcloud_app/view/designsystem/base_icon.dart';

import '../../../view_model/calendar_view/calendar_base_view_model.dart';
import '../../../view_model/calendar_view/calendar_base_view_state.dart';
import '../../component/navigation_bar.dart';
import 'calendar_base_view.dart';

class CalendarMonthView extends BaseChildView<CalendarBaseView, CalendarBaseViewModel, CalendarBaseViewState> {
  CalendarMonthView({super.key});

  final horizontalPaddingSize = 23.sp;
  final boxGap = 5.sp;
  final dayOfWeekFontSize = 18.sp;

  @override
  Widget render(BuildContext context, CalendarBaseViewModel action, CalendarBaseViewState state) {
    final fullWidth = MediaQuery.of(context).size.width;
    final boxWidth = (fullWidth - horizontalPaddingSize * 2 - boxGap * 6) / 7;

    return Scaffold(
      backgroundColor: BaseColor.defaultBackgroundColor,
      bottomNavigationBar: BaseNavigationBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            monthViewTopBar(action, state),
            SizedBox(height: 20.sp),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPaddingSize),
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: boxWidth / 2 - (dayOfWeekFontSize / 2)),
                    child: dayOfWeekTitle(),
                  ),
                  SizedBox(height: 10.sp),
                  drawCalendar(action, state, boxWidth: boxWidth, boxGap: boxGap)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget monthViewTopBar(CalendarBaseViewModel action, CalendarBaseViewState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TouchableOpacity(onTap: () => action.changeMonth(-1), child: const Icon(BaseIcon.arrowLeft)),
          TouchableOpacity(
            onTap: action.onTapTitle,
              child: Text(
            '${state.currentYear}년 ${state.currentMonth}월',
            style: TextStyle(
              color: BaseColor.warmGray600,
              fontSize: 16.sp,
            ),
          )
          ),
          TouchableOpacity(onTap: () => action.changeMonth(1), child: const Icon(BaseIcon.arrowRight)),
        ],
      ),
    );
  }

  Widget drawCalendar(CalendarBaseViewModel action, CalendarBaseViewState state, {required double boxWidth, required double boxGap}) {
    final monthGrid = state.getMonthGrid();
    return Column(children: [
      for(List<int> week in monthGrid)...[
        Row(
          children: [
            for(int dayOfWeek = 0; dayOfWeek < week.length; dayOfWeek++)...[
              week[dayOfWeek] == -1 ? SizedBox(width: boxWidth) : createDayBox(day: week[dayOfWeek], color: BaseColor.red400, boxWidth: boxWidth),
              if (dayOfWeek != week.length - 1) SizedBox(width: boxGap)
            ]
          ],
        ),
        SizedBox(height: boxGap),
      ]
    ]);
  }

  Widget createDayBox({required int day, required Color color, required double boxWidth}) {
    return Container(
      width: boxWidth,
      height: boxWidth,
      decoration: BoxDecoration(
        border: Border.all(color: BaseColor.warmGray300),
        borderRadius: BorderRadius.circular(15),

      ),
      child:   Center(
        child: Text(
          day.toString(),
          style: TextStyle(
            color: BaseColor.warmGray500,
            fontSize: 18.sp,
          ),
        ),
      )
      ,
    );
  }

  Widget dayOfWeekTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '일',
          style: TextStyle(
            color: BaseColor.red400,
            fontSize: dayOfWeekFontSize,
          ),
        ),
        Text(
          '월',
          style: TextStyle(
            color: BaseColor.warmGray600,
            fontSize: dayOfWeekFontSize,
          ),
        ),
        Text(
          '화',
          style: TextStyle(
            color: BaseColor.warmGray600,
            fontSize: dayOfWeekFontSize,
          ),
        ),
        Text(
          '수',
          style: TextStyle(
            color: BaseColor.warmGray600,
            fontSize: dayOfWeekFontSize,
          ),
        ),
        Text(
          '목',
          style: TextStyle(
            color: BaseColor.warmGray600,
            fontSize: dayOfWeekFontSize,
          ),
        ),
        Text(
          '금',
          style: TextStyle(
            color: BaseColor.warmGray600,
            fontSize: dayOfWeekFontSize,
          ),
        ),
        Text(
          '토',
          style: TextStyle(
            color: BaseColor.green400,
            fontSize: dayOfWeekFontSize,
          ),
        ),
      ],
    );
  }

}
