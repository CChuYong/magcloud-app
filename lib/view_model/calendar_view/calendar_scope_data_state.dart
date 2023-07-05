import 'package:flutter/cupertino.dart';
import 'package:magcloud_app/core/model/diary.dart';

import '../../core/model/mood.dart';

abstract class CalendarScopeData {}

class CalendarYearViewScopeData extends CalendarScopeData {
  final Map<int, Mood> monthlyMood;

  CalendarYearViewScopeData(this.monthlyMood);
}

class CalendarMonthViewScopeData extends CalendarScopeData {
  final Map<int, Mood> dailyMood;

  CalendarMonthViewScopeData(this.dailyMood);
}

class CalendarDailyViewScopeData extends CalendarScopeData {
  final TextEditingController diaryTextController = TextEditingController();
  final Diary currentDiary;

  CalendarDailyViewScopeData(this.currentDiary) {
    diaryTextController.text = currentDiary.content;
  }
}
