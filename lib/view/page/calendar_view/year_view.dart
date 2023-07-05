import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/core/framework/base_child_view.dart';
import 'package:magcloud_app/core/util/date_parser.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';
import 'package:magcloud_app/view/designsystem/base_icon.dart';

import '../../../view_model/calendar_view/calendar_base_view_model.dart';
import '../../../view_model/calendar_view/calendar_base_view_state.dart';
import '../../component/navigation_bar.dart';
import 'calendar_base_view.dart';

class CalendarYearView extends BaseChildView<CalendarBaseView, CalendarBaseViewModel, CalendarBaseViewState> {
   CalendarYearView({super.key});

  @override
  Widget render(BuildContext context, CalendarBaseViewModel action, CalendarBaseViewState state) {
    final fullWidth = MediaQuery.of(context).size.width;
    final boxWidth = (fullWidth - 100.sp) / 4;
    return Scaffold(
      backgroundColor: BaseColor.defaultBackgroundColor,
      bottomNavigationBar: BaseNavigationBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            yearViewTopBar(action, state),
            SizedBox(height: 20.sp),
            for(int j = 0; j < 3; j++)... [
              Row(
                children: [
                  SizedBox(width: 20.sp),
                  for(int x = (j*4) + 1; x<= (j*4) + 4;x++)...[
                    createMonthBox(action, month: x, color: BaseColor.green200, boxWidth: boxWidth),
                    SizedBox(width: 20.sp),
                  ],
                ],
              ),
              SizedBox(height: 20.sp),
            ]
          ],
        ),
      ),
    );
  }

  Widget yearViewTopBar(CalendarBaseViewModel action, CalendarBaseViewState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TouchableOpacity(onTap: () => action.changeYear(-1), child: const Icon(BaseIcon.arrowLeft)),
          TouchableOpacity(
              child: Text(
            '${state.currentYear}년',
            style: TextStyle(
              color: BaseColor.warmGray600,
              fontSize: 16.sp,
            ),
          )
          )
          ,
          TouchableOpacity(onTap: () => action.changeYear(1), child: const Icon(BaseIcon.arrowRight)),
        ],
      ),
    );
  }

  Widget createMonthBox(CalendarBaseViewModel action, {required int month, required Color color, required double boxWidth}) {
    final isInvisible = DateParser.getCurrentYear() == action.state.currentYear && DateParser.getCurrentMonth() < month;
    return TouchableOpacity(
      onTap: () => isInvisible ? null : action.onTapMonthBox(month),
        child: Container(
          width: boxWidth,
          height: boxWidth,
          decoration: BoxDecoration(
            border: Border.all(color: BaseColor.warmGray300),
            borderRadius: BorderRadius.circular(15),
            color: isInvisible ? BaseColor.warmGray200 : BaseColor.warmGray300,
          ),
          child:   Center(
            child: Text(
              '${month}월',
              style: TextStyle(
                color: BaseColor.warmGray500,
                fontSize: 18.sp,
              ),
            ),
          )
          ,
        )
    );
  }

}
