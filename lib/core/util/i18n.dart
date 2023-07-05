final map = {
  "magcloud": "매지구름",
  "navigation_friends": "내 친구",
  "navigation_calendar": "달력",
  "navigation_more": "더보기",
  "generic_year" : "년",
  "generic_month": "월",
  "generic_day": "일",
  "generic_simple_monday" : "일",
  "generic_simple_tuesday" : "월",
  "generic_simple_wednesday" : "화",
  "generic_simple_thursday" : "수",
  "generic_simple_friday" : "목",
  "generic_simple_saturday" : "금",
  "generic_simple_sunday" : "토",
  "message_login_view_description": "매일 당신의 이야기를 들어드릴게요",
  "message_cannot_move_to_future": "미래로는 이동할 수 없어요",
};

final engMap = {
  "magcloud": "MagCloud",
  "navigation_friends": "Friends",
  "navigation_calendar": "Calendar",
  "navigation_more": "More",
  "generic_year" : "",
  "generic_month": "",
  "generic_day": "",
  "generic_simple_monday" : "S",
  "generic_simple_tuesday" : "M",
  "generic_simple_wednesday" : "T",
  "generic_simple_thursday" : "W",
  "generic_simple_friday" : "T",
  "generic_simple_saturday" : "F",
  "generic_simple_sunday" : "S",
  "message_login_view_description": "Your daily heart listener,",
  "message_cannot_move_to_future": "You cannot travel to future!",
};



String message(String key) {
  return map[key] ?? "UNKNOWN KEYWORD";
}
