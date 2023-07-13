import 'package:flutter/cupertino.dart';
import 'package:magcloud_app/core/model/diary.dart';

import '../../core/model/mood.dart';

abstract class CalendarScopeData {
  final bool isMyScope;

  CalendarScopeData({required this.isMyScope});
}

class CalendarYearViewScopeData extends CalendarScopeData {
  final Map<int, Mood> monthlyMood;

  CalendarYearViewScopeData(this.monthlyMood, bool isMyScope)
      : super(isMyScope: isMyScope);

  static CalendarYearViewScopeData mock() =>
      CalendarYearViewScopeData({}, true);
}

class CalendarMonthViewScopeData extends CalendarScopeData {
  final Map<int, Mood> dailyMood;

  CalendarMonthViewScopeData(this.dailyMood, bool isMyScope)
      : super(isMyScope: isMyScope);

  static CalendarMonthViewScopeData mock() =>
      CalendarMonthViewScopeData({}, true);
}

class CalendarDailyViewScopeData extends CalendarScopeData {
  final TextEditingController diaryTextController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final Diary currentDiary;
  String? imageUrl;
  late Mood currentMood;

  CalendarDailyViewScopeData(this.currentDiary, bool isMyScope)
      : super(isMyScope: isMyScope) {
    diaryTextController.text = currentDiary.content;
    currentMood = currentDiary.mood;
    imageUrl = currentDiary.imageUrl;
  }

  static CalendarDailyViewScopeData mock() =>
      CalendarDailyViewScopeData(Diary.create(), true);
}
