final isKorea = true;

final map = {
  "magcloud": "매지구름",
  "navigation_friends": "내 친구",
  "navigation_calendar": "달력",
  "navigation_more": "더보기",
  "generic_mood_sad": "슬픈",
  "generic_mood_angry": "화난",
  "generic_mood_happy": "행복한",
  "generic_mood_amazed": "놀란",
  "generic_mood_nervous": "긴장된",
  "generic_mood_neutral": "중립의",
  "generic_year": "년",
  "generic_month": "월",
  "generic_day": "일",
  "generic_simple_monday": "월",
  "generic_simple_tuesday": "화",
  "generic_simple_wednesday": "수",
  "generic_simple_thursday": "목",
  "generic_simple_friday": "금",
  "generic_simple_saturday": "토",
  "generic_simple_sunday": "일",
  "generic_full_monday": "월요일",
  "generic_full_tuesday": "화요일",
  "generic_full_wednesday": "수요일",
  "generic_full_thursday": "목요일",
  "generic_full_friday": "금요일",
  "generic_full_saturday": "토요일",
  "generic_full_sunday": "일요일",
  "message_login_view_description": "매일 당신의 이야기를 들어드릴게요",
  "message_cannot_move_to_future": "미래로는 이동할 수 없어요",
  "message_offline_mode_activated": "오프라인 모드가 되었어요",
  "message_online_mode_activated": "온라인으로 전환되었어요",
  "message_diary_saved_offline":
      "서버와 연결할 수 없어 오프라인에 일기를 저장했어요. 서버와 연결되면 다시 저장할게요!",
  "message_login_failed": "로그인에 실패했어요",
  "message_offline_cannot_view_friends": "오프라인 모드는 친구의 일기를 볼 수 없어요"
};

final engMap = {
  "magcloud": "MagCloud",
  "navigation_friends": "Friends",
  "navigation_calendar": "Calendar",
  "navigation_more": "More",
  "generic_mood_sad": "sad",
  "generic_mood_angry": "angry",
  "generic_mood_happy": "happy",
  "generic_mood_amazed": "amazed",
  "generic_mood_nervous": "nervous",
  "generic_mood_neutral": "neutral",
  "generic_year": "",
  "generic_month": "",
  "generic_day": "",
  "generic_simple_monday": "M",
  "generic_simple_tuesday": "T",
  "generic_simple_wednesday": "W",
  "generic_simple_thursday": "T",
  "generic_simple_friday": "F",
  "generic_simple_saturday": "S",
  "generic_simple_sunday": "S",
  "generic_full_monday": "MON",
  "generic_full_tuesday": "TUE",
  "generic_full_wednesday": "WED",
  "generic_full_thursday": "THU",
  "generic_full_friday": "FRI",
  "generic_full_saturday": "SAT",
  "generic_full_sunday": "SUN",
  "message_login_view_description": "Your daily heart listener,",
  "message_cannot_move_to_future": "You cannot travel to future!",
  "message_offline_mode_activated": "You've been away from server...",
  "message_online_mode_activated": "You've been connected to server",
  "message_diary_saved_offline":
      "Diary saved locally due to internet connection",
  "message_login_failed": "Login failed..",
  "message_offline_cannot_view_friends": "Offline mode cannot see friends"
};

String message(String key) {
  return (isKorea ? map : engMap)[key] ?? "UNKNOWN KEYWORD";
}

String dayOfWeek(int ordinal) {
  switch (ordinal) {
    case 1:
      return message("generic_full_sunday");
    case 2:
      return message("generic_full_monday");
    case 3:
      return message("generic_full_tuesday");
    case 4:
      return message("generic_full_wednesday");
    case 5:
      return message("generic_full_thursday");
    case 6:
      return message("generic_full_friday");
    case 7:
    default:
      return message("generic_full_saturday");
  }
}
