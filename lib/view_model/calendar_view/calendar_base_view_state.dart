import 'package:flutter/cupertino.dart';
import 'package:magcloud_app/core/util/date_parser.dart';
import 'package:magcloud_app/view_model/calendar_view/calendar_base_view_model.dart';

class CalendarBaseViewState {
  int currentYear;
  int currentMonth;
  CalendarViewScope scope;

  CalendarBaseViewState(this.currentYear, this.currentMonth, this.scope);

  List<List<int>> getMonthGrid() {
    //바깥쪽 리스트 -> 주
    //안쪽 리스트 -> 일
    final weekList = List.generate(6, (index) => List.generate(7, (index) => -1));
    final lastDay = DateParser.getLastDayOfMonth(currentYear, currentMonth);
    var currentWeekPointer = 0;

    final monthlyFirstDayOfWeek = DateParser.getFirstDayOfWeekOfMonth(currentYear, currentMonth);
    var currentDayOfWeek = monthlyFirstDayOfWeek == 7 ? 1 : monthlyFirstDayOfWeek + 1;
    for(int day = 1; day <= lastDay; day++){
      weekList[currentWeekPointer][currentDayOfWeek - 1] = day;
      if(currentDayOfWeek == 7) {
        currentDayOfWeek = 1;
        currentWeekPointer++;
      } else {
        currentDayOfWeek += 1;
      }
    }
    return weekList;
  }
}
