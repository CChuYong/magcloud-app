
import 'package:flutter/cupertino.dart';
import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/core/util/date_parser.dart';
import 'package:magcloud_app/core/util/snack_bar_util.dart';
import 'package:magcloud_app/view/page/calendar_view/month_view.dart';
import 'package:magcloud_app/view/page/calendar_view/year_view.dart';

import '../../view/page/calendar_view/calendar_base_view.dart';
import 'calendar_base_view_state.dart';

enum CalendarViewScope{
  YEAR, MONTH, DAILY
}
class CalendarBaseViewModel extends BaseViewModel<CalendarBaseView, CalendarBaseViewModel, CalendarBaseViewState> {
  CalendarBaseViewModel({int? initialMonth, int? initialYear}) : super(
      CalendarBaseViewState(
          initialYear ?? DateParser.getCurrentYear(),
          initialMonth ?? DateParser.getCurrentMonth(),
          CalendarViewScope.MONTH,
      ),
  );

  Widget Function() getRoutedWidgetBuilder() {
    switch(state.scope) {
      case CalendarViewScope.YEAR:
        return () => CalendarYearView();
      case CalendarViewScope.MONTH:
        return () => CalendarMonthView();
      default:
        throw Exception();
    }
  }



  @override
  Future<void> initState() async {}

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
        SnackBarUtil.errorSnackBar(message: '미래로는 이동할 수 없어요!');
      return;
    }
    setState(() {
      state.currentYear = targetYear;
      state.currentMonth = targetMonth;
    });
  }

  Future<void> changeYear(int delta) async {
    setState(() {
      state.currentYear += delta;
    });
  }

  Future<void> onTapMonthBox(int month) async {
    setState(() {
      state.currentMonth = month;
      state.scope = CalendarViewScope.MONTH;
    });
  }

  Future<void> onTapYearTitle() async {

  }

  Future<void> onTapTitle() async {
    setState(() {
      state.scope = CalendarViewScope.YEAR;
    });
  }
}
