
import 'package:flutter/cupertino.dart';
import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/core/util/date_parser.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/core/util/snack_bar_util.dart';
import 'package:magcloud_app/view/page/calendar_view/month_view.dart';
import 'package:magcloud_app/view/page/calendar_view/year_view.dart';

import '../../view/page/calendar_view/calendar_base_view.dart';
import '../../view/page/calendar_view/daily_diary_view.dart';
import 'calendar_base_view_state.dart';

enum CalendarViewScope{
  YEAR, MONTH, DAILY
}
class CalendarBaseViewModel extends BaseViewModel<CalendarBaseView, CalendarBaseViewModel, CalendarBaseViewState> {
  CalendarBaseViewModel({int? initialMonth, int? initialYear, int? initialDay}) : super(
      CalendarBaseViewState(
          initialYear ?? DateParser.getCurrentYear(),
          initialMonth ?? DateParser.getCurrentMonth(),
          initialDay ?? DateParser.getCurrentDay(),
          CalendarViewScope.MONTH,
      ),
  );

  void setScope(CalendarViewScope scope) {
    state.scope = scope;
  }

  Widget Function() getRoutedWidgetBuilder() {
    switch(state.scope) {
      case CalendarViewScope.YEAR:
        return () => CalendarYearView();
      case CalendarViewScope.MONTH:
        return () => CalendarMonthView();
      case CalendarViewScope.DAILY:
        return () => CalendarDailyDiaryView();
    }
  }


  @override
  Future<void> initState() async {}

  Future<void> changeDay(int delta) async {
    final now = DateTime.now();
    final afterDelta = DateTime(state.currentYear, state.currentMonth, state.currentDay + delta);
    if (afterDelta.isAfter(now)) {
      SnackBarUtil.errorSnackBar(message: message("message_cannot_move_to_future"));
      return;
    }
    setState(() {
      state.currentYear = afterDelta.year;
      state.currentMonth = afterDelta.month;
      state.currentDay = afterDelta.day;
    });
  }

  Future<void> changeMonth(int delta) async {
    final afterDelta = state.currentMonth + delta;
    int targetMonth = state.currentMonth;
    int targetYear = state.currentYear;
    if (afterDelta < 1) {
      targetMonth = 12;
      targetYear -= 1;
    } else if (afterDelta > 12) {
      targetMonth = 1;
      targetYear += 1;
    } else {
      targetMonth = afterDelta;
    }

    final currentYear = DateParser.getCurrentYear();
    final currentMonth = DateParser.getCurrentMonth();
    if ((targetYear == currentYear && targetMonth > currentMonth) ||
        targetYear > currentYear) {
        SnackBarUtil.errorSnackBar(message: message("message_cannot_move_to_future"));
      return;
    }
    setState(() {
      state.currentYear = targetYear;
      state.currentMonth = targetMonth;
    });
  }

  Future<void> changeYear(int delta) async {
    final afterDelta = state.currentYear + delta;
    if(afterDelta > DateParser.getCurrentYear()) {
      SnackBarUtil.errorSnackBar(message: message("message_cannot_move_to_future"));
      return;
    }
    setState(() {
      state.currentYear = afterDelta;
    });
  }

  Future<void> onTapMonthBox(int month) async {
    setState(() {
      state.currentMonth = month;
      setScope(CalendarViewScope.MONTH);
    });
  }

  Future<void> onTapDayBox(int day) async {
    setState(() {
      state.currentDay = day;
      setScope(CalendarViewScope.DAILY);
    });
  }

  Future<void> onTapYearTitle() async {
    //이럼 머야???
  }

  Future<void> onTapMonthTitle() async {
    setState(() {
      setScope(CalendarViewScope.YEAR);
    });
  }

  Future<void> onTapDayTitle() async {
    setState(() {
      setScope(CalendarViewScope.MONTH);
    });
  }
}
