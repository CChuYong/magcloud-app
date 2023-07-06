import 'package:magcloud_app/core/model/daily_user.dart';
import 'package:magcloud_app/core/service/auth_service.dart';
import 'package:magcloud_app/core/util/date_parser.dart';
import 'package:magcloud_app/view_model/calendar_view/calendar_base_view_model.dart';

import '../../core/model/user.dart';
import 'calendar_scope_data_state.dart';

class CalendarBaseViewState {
  int currentYear;
  int currentMonth;
  int currentDay;
  CalendarViewScope scope;
  CalendarScopeData scopeData;
  List<DailyUser> dailyFriends = List.empty();

  CalendarBaseViewState(this.currentYear, this.currentMonth, this.currentDay,
      this.scope, this.scopeData);

  List<List<int>> getMonthGrid() {
    //바깥쪽 리스트 -> 주
    //안쪽 리스트 -> 일
    final weekList =
        List.generate(6, (index) => List.generate(7, (index) => -1));
    final lastDay = DateParser.getLastDayOfMonth(currentYear, currentMonth);
    final now = DateTime.now();
    var currentWeekPointer = 0;

    final monthlyFirstDayOfWeek =
        DateParser.getFirstDayOfWeekOfMonth(currentYear, currentMonth);
    var currentDayOfWeek =
        monthlyFirstDayOfWeek == 7 ? 1 : monthlyFirstDayOfWeek + 1;
    for (int day = 1; day <= lastDay; day++) {
      weekList[currentWeekPointer][currentDayOfWeek - 1] =
          DateTime(currentYear, currentMonth, day).isAfter(now)
              ? -1 * day
              : day;
      if (currentDayOfWeek == 7) {
        currentDayOfWeek = 1;
        currentWeekPointer++;
      } else {
        currentDayOfWeek += 1;
      }
    }
    return weekList;
  }
}
