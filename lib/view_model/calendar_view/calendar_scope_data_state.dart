import 'package:flutter/cupertino.dart';
import 'package:magcloud_app/core/model/diary.dart';

abstract class CalendarScopeData {}

class CalendarYearViewScopeData extends CalendarScopeData {

}

class CalendarMonthViewScopeData extends CalendarScopeData {

}

class CalendarDailyViewScopeData extends CalendarScopeData {
  final TextEditingController diaryTextController = TextEditingController();
  final Diary currentDiary;

  CalendarDailyViewScopeData(this.currentDiary) {
    diaryTextController.text = currentDiary.content;
  }
}
