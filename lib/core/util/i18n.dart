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
  "message_offline_mode_activated": "오프라인 모드가 되었어요",
  "message_online_mode_activated": "온라인으로 전환되었어요",
  "message_diary_saved_offline": "서버와 연결할 수 없어 오프라인에 일기를 저장했어요. 서버와 연결되면 다시 저장할게요!"
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
  "message_offline_mode_activated": "You've been away from server...",
  "message_online_mode_activated": "You've been connected to server",
  "message_diary_saved_offline": "Diary saved locally due to internet connection"
};



String message(String key) {
  return map[key] ?? "UNKNOWN KEYWORD";
}
