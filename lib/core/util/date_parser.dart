import 'package:intl/intl.dart';
import 'package:magcloud_app/core/util/i18n.dart';

class DateParser {
  static DateFormat dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  static DateFormat dateFormat = DateFormat('yyyy.MM.dd.');
  static DateFormat ymdSimpleFormat = DateFormat('yyyyMMdd');
  static DateFormat krMMdd = DateFormat('MM월 dd일');
  static DateFormat lastMessageTimeFormat = DateFormat("hh:mm");

  static int nowAtMillis() => DateTime.now().millisecondsSinceEpoch;

  static DateTime fromTimeStamp(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: false);
  }

  static String parseAwayFrom(int millis) {
    return dateTimeFormat.format(fromTimeStamp(millis));
  }

  static String formatYmd(int year, int month, int day) {
    final dateTime = DateTime(year, month, day);
    return ymdSimpleFormat.format(dateTime);
  }

  static String formatDateTime(DateTime dateTime) {
    return ymdSimpleFormat.format(dateTime);
  }

  static DateTime parseYmd(String ymd) {
    int year = int.parse(ymd.substring(0, 4));
    int month = int.parse(ymd.substring(4, 6));
    int day = int.parse(ymd.substring(6, 8));
    return DateTime(year, month, day);
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

  static int getWeekday(int year, int month, int day) {
    final dateTime = DateTime(year, month, day);
    final weekDay = dateTime.weekday;
    return weekDay == 7 ? 1 : weekDay + 1;
  }

  static int getCurrentYear() => DateTime.now().year;

  static int getCurrentMonth() => DateTime.now().month;

  static int getCurrentDay() => DateTime.now().day;

  static String formatLocaleYmd(DateTime date) {
    if (isKorea) {
      return DateFormat('y년 MMM d일 E요일', 'ko_KR').format(date);
    }
    return DateFormat('EEE, MMM d, y', 'en_US').format(date);
  }

  static String formatLocaleYm(DateTime date) {
    if (isKorea) {
      return DateFormat('y년 MMM', 'ko_KR').format(date);
    }
    return DateFormat('MMM y', 'en_US').format(date);
  }

  static String formatLocaleMonth(int month) {
    final date = DateTime(2020, month);
    if (isKorea) {
      return DateFormat('MMM', 'ko_KR').format(date);
    }
    return DateFormat('MMM', 'en_US').format(date);
  }

  static String gapBetweenNow(int timestamp) {
    final gap = (nowAtMillis() - timestamp) / 1000;
    if (gap < 3600) {
      return "${(gap / 60).toInt()}${message('generic_minute')}";
    } else if (gap < 86400) {
      return "${(gap / 3600).toInt()}${message('generic_hour')}";
    } else {
      return "${(gap / 86400).toInt()}${message('generic_days')}";
    }
  }
}
