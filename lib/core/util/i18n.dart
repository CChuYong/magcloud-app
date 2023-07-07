import 'package:magcloud_app/core/framework/state_store.dart';

bool isKorea = true;

void toggleEng() {
  setLanguage(!isKorea);
}

void setLanguage(bool korea) {
  isKorea = korea;
  StateStore.setBool('isKorea', korea);
}

final map = {
  "magcloud": "매지구름",
  "magcloud_with_name": "%s님의 매지구름",
  "magcloud_with_me": "나의 매지구름",
  "navigation_friends": "내 친구",
  "navigation_calendar": "달력",
  "navigation_more": "더보기",
  "menu_settings": "설정",
  "menu_my_profiles": "내 프로필 설정",
  "menu_notification": "알림 설정",
  "menu_fonts": "글씨체 설정",
  "menu_language": "언어 설정",
  "menu_info": "정보",
  "menu_notice": "공지사항",
  "menu_privacy": "개인정보 처리방침",
  "menu_app_info": "어플리케이션 정보",
  "menu_logout": "로그아웃",
  "generic_me": "나",
  "generic_app_version": "어플리케이션 버전",
  "generic_app_name": "어플리케이션 이름",
  "generic_app_build_no": "빌드 번호",
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
  "generic_search": "검색",
  "generic_add_friend": "친구 추가",
  "generic_friend_share_diary": "일기 공유",
  "generic_friend_unshare_diary": "일기 공유 취소",
  "generic_friend_delete": "삭제",
  "generic_preview": "미리보기",
  "generic_login_with_apple": "Apple로 로그인",
  "generic_login_with_google": "Google로 로그인",
  "generic_selected_language": "선택된 언어",
  "generic_selected_font": "선택된 글씨체",
  "generic_font_size": "글씨체 크기",
  "generic_select_emotion": "오늘의 감정을 선택해주세요",
  "generic_apply": "적용하기",
  "message_font_example_text": "매지구름아 안녕, 한국에 온걸 환영해!",
  "message_login_view_description": "매일 당신의 이야기를 들어드릴게요",
  "message_cannot_move_to_future": "미래의 일기는 볼 수 없어요",
  "message_offline_mode_activated": "오프라인 모드가 되었어요",
  "message_online_mode_activated": "온라인으로 전환되었어요",
  "message_diary_saved_offline":
      "서버와 연결할 수 없어 오프라인에 일기를 저장했어요. 서버와 연결되면 다시 저장할게요!",
  "message_login_failed": "로그인에 실패했어요",
  "message_offline_cannot_view_friends": "오프라인 모드는 친구의 일기를 볼 수 없어요",
  "message_total_friend_count": "총 %s 명의 친구",
  "message_language_settings_info": "앱 내부에서 표기되는 언어에요. 일기 내용, 친구 이름등은 변하지 않아요",
  "message_font_settings_info":
      "일기장에서 표기되는 글씨체에요. 나에게 보여지는 폰트여서 친구에게는 적용되지 않아요.",
};

final engMap = {
  "magcloud": "MagCloud",
  "magcloud_with_name": "%s's MagCloud",
  "magcloud_with_me": "My MagCloud",
  "navigation_friends": "Friends",
  "navigation_calendar": "Calendar",
  "navigation_more": "More",
  "menu_settings": "Settings",
  "menu_my_profiles": "Customize Profile",
  "menu_notification": "Notification Setting",
  "menu_fonts": "Font Setting",
  "menu_language": "Language Setting",
  "menu_info": "Etc",
  "menu_notice": "App Notice",
  "menu_privacy": "Privacy Policy",
  "menu_app_info": "Application Info",
  "menu_logout": "Logout",
  "generic_me": "Me",
  "generic_app_version": "Application Version",
  "generic_app_name": "Application Name",
  "generic_app_build_no": "Build Number",
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
  "generic_search": "Search",
  "generic_add_friend": "Add Friend",
  "generic_friend_share_diary": "Share Diary",
  "generic_friend_unshare_diary": "UnShare Diary",
  "generic_friend_delete": "Delete",
  "generic_preview": "Preview",
  "generic_login_with_apple": "Login with Apple",
  "generic_login_with_google": "Login with Google",
  "generic_selected_language": "Selected Language",
  "generic_selected_font": "Selected Font",
  "generic_font_size": "Font Size",
  "generic_select_emotion": "Please select today's emotion",
  "generic_apply": "Apply",
  "message_font_example_text": "Hello MagCloud, Welcome to Korea!",
  "message_login_view_description": "Your daily heart listener,",
  "message_cannot_move_to_future": "You cannot travel to future!",
  "message_offline_mode_activated": "You've been away from server...",
  "message_online_mode_activated": "You've been connected to server",
  "message_diary_saved_offline":
      "Diary saved locally due to internet connection",
  "message_login_failed": "Login failed..",
  "message_offline_cannot_view_friends": "Offline mode cannot see friends",
  "message_total_friend_count": "Total %s friends",
  "message_language_settings_info":
      "Only applied to MagCloud application. This settings cannot translate diaries.",
  "message_font_settings_info":
      "This is display font for diary. Only applied to me, not friends.",
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
