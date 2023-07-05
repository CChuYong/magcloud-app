import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/core/framework/base_child_view.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';
import 'package:magcloud_app/view/designsystem/base_icon.dart';

import '../../../view_model/calendar_view/calendar_base_view_model.dart';
import '../../../view_model/calendar_view/calendar_base_view_state.dart';
import '../../component/navigation_bar.dart';
import 'calendar_base_view.dart';

class CalendarDailyDiaryView extends BaseChildView<CalendarBaseView, CalendarBaseViewModel, CalendarBaseViewState> {
  CalendarDailyDiaryView({super.key});

  @override
  Widget render(BuildContext context, CalendarBaseViewModel action, CalendarBaseViewState state) {
    return Scaffold(
      backgroundColor: BaseColor.defaultBackgroundColor,
      bottomNavigationBar: BaseNavigationBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dailyViewTopBar(action, state),
            SizedBox(height: 20.sp),
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
            '${state.currentYear}년 ${state.currentMonth}월 ${state.currentDay}일',
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


}
