import 'package:flutter/cupertino.dart';
import 'package:magcloud_app/core/model/diary.dart';

import '../../core/model/mood.dart';
import '../../view/component/taggable_text_editing_controller.dart';

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
  final TaggableTextEditingController diaryTextController = TaggableTextEditingController();
  final FocusNode focusNode = FocusNode();
  final Diary currentDiary;
 // String? tagSelectionText;
  int? tagSelectionStart = null;
  int? tagSelectionEnd = null;
  String? imageUrl;
  late Mood currentMood;

  CalendarDailyViewScopeData(this.currentDiary, bool isMyScope)
      : super(isMyScope: isMyScope) {
    diaryTextController.text = currentDiary.content;
    currentMood = currentDiary.mood;
    imageUrl = currentDiary.imageUrl;
  }

  String? getTagSelectionText() {
    if(tagSelectionStart != null && tagSelectionEnd != null){
      return diaryTextController.text.substring(tagSelectionStart!, tagSelectionEnd!);
  }
    return null;

  }

  static CalendarDailyViewScopeData mock() =>
      CalendarDailyViewScopeData(Diary.create(), true);
}
