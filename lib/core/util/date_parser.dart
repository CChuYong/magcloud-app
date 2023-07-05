import 'package:intl/intl.dart';

class DateParser {
  static DateFormat dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  static DateFormat dateFormat = DateFormat('yyyy.MM.dd.');
  static DateFormat krMMdd = DateFormat('MM월 dd일');
  static DateFormat lastMessageTimeFormat = DateFormat("hh:mm");

  static DateTime fromTimeStamp(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: false);
  }

  static String timeStampAsDateTime(int timestamp) {
    return dateTimeFormat.format(fromTimeStamp(timestamp));
  }

  static String timeStampAsDate(int timestamp) {
    return dateFormat.format(fromTimeStamp(timestamp));
  }

  static String lastMessageFormat(int timestamp) {
    final date = fromTimeStamp(timestamp);
    final diffOfToday = calculateDifference(date);
    if (diffOfToday == 0) {
      String dayNight = date.hour < 12 ? "오전 " : "오후 ";
      return dayNight + lastMessageTimeFormat.format(fromTimeStamp(timestamp));
    }
    return krMMdd.format(date);
  }

  static int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  static int getLastDayOfMonth(int year, int month) {
    final dateTime = DateTime(year, month + 1, 0);
    return dateTime.day;
  }

  static int getFirstDayOfWeekOfMonth(int year, int month) {
    final dateTime = DateTime(year, month, 1);
    return dateTime.weekday;
  }

  static int getCurrentYear() => DateTime.now().year;

  static int getCurrentMonth() => DateTime.now().month;

  static int getCurrentDay() => DateTime.now().day;
}
