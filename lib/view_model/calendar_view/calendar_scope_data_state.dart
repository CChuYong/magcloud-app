import 'package:flutter/cupertino.dart';
import 'package:magcloud_app/core/model/diary.dart';

import '../../core/model/mood.dart';

abstract class CalendarScopeData {}

class CalendarYearViewScopeData extends CalendarScopeData {
  final Map<int, Mood> monthlyMood;

  CalendarYearViewScopeData(this.monthlyMood);

  static CalendarYearViewScopeData mock() => CalendarYearViewScopeData({});
}

class CalendarMonthViewScopeData extends CalendarScopeData {
  final Map<int, Mood> dailyMood;

  CalendarMonthViewScopeData(this.dailyMood);

  static CalendarMonthViewScopeData mock() => CalendarMonthViewScopeData({});
}

class CalendarDailyViewScopeData extends CalendarScopeData {
  final TextEditingController diaryTextController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final Diary currentDiary;
  late Mood currentMood;

  CalendarDailyViewScopeData(this.currentDiary) {
    diaryTextController.text = currentDiary.content;
    currentMood = currentDiary.mood;
  }

  static CalendarDailyViewScopeData mock() =>
      CalendarDailyViewScopeData(Diary.create());
}
