import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:magcloud_app/core/api/open_api.dart';
import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/core/framework/state_store.dart';
import 'package:magcloud_app/core/model/user.dart';
import 'package:magcloud_app/core/service/diary_service.dart';
import 'package:magcloud_app/core/service/friend_diary_service.dart';
import 'package:magcloud_app/core/service/online_service.dart';
import 'package:magcloud_app/core/service/tag_resolver.dart';
import 'package:magcloud_app/core/service/user_service.dart';
import 'package:magcloud_app/core/util/extension.dart';
import 'package:magcloud_app/core/util/hash_util.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/core/util/snack_bar_util.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/global_routes.dart';
import 'package:magcloud_app/view/dialog/mood_change_dialog.dart';
import 'package:magcloud_app/view/page/calendar_view/month_view.dart';
import 'package:magcloud_app/view/page/calendar_view/year_view.dart';
import 'package:magcloud_app/view_model/calendar_view/calendar_scope_data_state.dart';
import 'package:dio/dio.dart';
import '../../core/model/diary.dart';
import '../../core/model/navigate_detail.dart';
import '../../core/util/debouncer.dart';
import '../../core/util/image_picker.dart';
import '../../view/page/calendar_view/calendar_base_view.dart';
import '../../view/page/calendar_view/daily_diary_view.dart';
import 'calendar_base_view_state.dart';

enum CalendarViewScope { YEAR, MONTH, DAILY }

class CalendarBaseViewModel extends BaseViewModel<CalendarBaseView,
    CalendarBaseViewModel, CalendarBaseViewState> {
  final DiaryService diaryService = inject<DiaryService>();
  final UserService userService = inject<UserService>();
  final OnlineService onlineService = inject<OnlineService>();
  final FriendDiaryService friendDiaryService = inject<FriendDiaryService>();

  static bool navigateToMyPage = false;
  static NavigateDetail? nextNavigateDiary;

  bool isMeSelected() => state.selectedUser?.userId == state.dailyMe?.userId;

  bool forwardAction = false;
  bool animationStart = false;

  bool verticalForwardAction = false;
  bool verticalAnimationStart = false;

  bool isFriendBarOpen = StateStore.getBool("isFriendBarOpen", true);

  final Debouncer dragDebouncer = Debouncer(const Duration(milliseconds: 25));
  final Debouncer saveDebouncer = Debouncer(const Duration(milliseconds: 2500));

  @override
  void dispose() {
    StateStore.setBool("isFriendBarOpen", isFriendBarOpen);
    StateStore.setString("lastScope", state.scope.name);
    StateStore.setInt("currentYear", state.currentDate.year);
    StateStore.setInt("currentMonth", state.currentDate.month);
    StateStore.setInt("currentDay", state.currentDate.day);
  }

  @override
  void onReloaded() {
    setStateAsync(() async {
      await initState();
    });
  }

  void refreshPage() async {
    setupVerticalAnimation(state.scope == CalendarViewScope.YEAR);
    setStateAsync(() async {
      await setScope(CalendarViewScope.MONTH);
    });
  }

  void toggleFriendBar() {
    setState(() {
      isFriendBarOpen = !isFriendBarOpen;
    });
  }

  void toggleOnline() {
//    GlobalRoute.splash();
    setState(() {
      OnlineService.invokeOnlineToggle();
    });
  }

  bool isOnline() => onlineService.isOnlineMode();

  CalendarBaseViewModel()
      : super(
          CalendarBaseViewState(
            DateTime.now(),
            StateStore.getString("lastScope")
                    ?.let((scope) => CalendarViewScope.values.byName(scope)) ??
                CalendarViewScope.MONTH,
          ),
        );

  @override
  Future<void> initState() async {
    if (isOnline()) {
      state.dailyFriends = await userService.getDailyFriends();
    }
    state.dailyMe = await userService.getDailyMe();
    state.selectedUser = state.dailyMe;
    if(nextNavigateDiary != null) {
      state.selectedUser = nextNavigateDiary!.user;
      state.currentDate = nextNavigateDiary!.ymd;
      await setScope(CalendarViewScope.DAILY);
      nextNavigateDiary = null;
      return;
    }
    CalendarViewScope newScope = state.scope;
    if(navigateToMyPage) {
      navigateToMyPage = false;
      await navigateToNow();
      newScope = CalendarViewScope.DAILY;
      print("Navigate to daily");
    }
    await setScope(newScope);
    print("NAvigate complete");
  }

  bool isRunning = false;

  Future<void> setScope(CalendarViewScope scope) async {
    await _setScope(scope);
  }

  Future<void> _setScope(CalendarViewScope scope) async {
    final previousScope = state.scope;
    if (previousScope == CalendarViewScope.DAILY) {
      final scopeData = state.scopeData as CalendarDailyViewScopeData;
      if (scopeData.isMyScope) {
        final lastDiary = scopeData.currentDiary;
        await diaryService.updateDiary(lastDiary, scopeData.currentMood,
            scopeData.diaryTextController.text, scopeData.imageUrl);
      }
    }
    try {
      if (onlineService.isOnlineMode() && !isMeSelected()) {
        await asyncLoading(() async {
          await applyWithFriendScope(scope);
          state.scope = scope;
        });
      } else {
        state.selectedUser = state.dailyMe;
        state.scope = scope;
        await applyWithMyScope(scope);
      }
    } catch (e) {
      state.scope = previousScope;
    }
  }

  Future<void> uploadImage() async {
    final scopeData = state.scopeData as CalendarDailyViewScopeData;
    if (!inject<OnlineService>().isOnlineMode()) {
      SnackBarUtil.errorSnackBar(
          message: message('message_offline_cannot_use_that'));
      return;
    }
    final image = await ImagePickerUtil.pickImage();
    await asyncLoading(() async {
      final openAPI = inject<OpenAPI>();
      if (image == null) return;
      final imageRequest = await openAPI.getImageRequest();
      await inject<Dio>().request(imageRequest.uploadUrl,
          data: image.bytes,
          options: Options(
              method: 'PUT', headers: {'Content-Type': image.mimeType}));

      SnackBarUtil.infoSnackBar(message: message('message_upload_succeed'));
      await setStateAsync(() async {
        scopeData.imageUrl = imageRequest.downloadUrl;
      });
    });
  }

  List<User> findFriendMatches(String text) {
    if(state.scopeData is CalendarDailyViewScopeData) {
      final matches = inject<TagResolver>().friendCache.values.toList().where((element) => element.nameTag.contains(text)).toList();
      return matches.sublist(0, min(8, matches.length));
    }
    return List.empty();
  }

  Future<void> applyWithMyScope(CalendarViewScope scope) async {
    switch (scope) {
      case CalendarViewScope.YEAR:
        final mood = await diaryService.getMonthlyMood(state.currentDate.year);
        setScopeData(CalendarYearViewScopeData(mood, true));
        break;
      case CalendarViewScope.MONTH:
        if (onlineService.isOnlineMode()) {
          diaryService
              .autoSync(state.currentDate.year, state.currentDate.month)
              .then((value) {
            if (value) {
              print("Sync result returned non-zero code");
              if (scope != CalendarViewScope.DAILY) {
                setStateAsync(() async {
                  await setScope(scope);
                });
              }
            }
          });
        }
        final mood = await diaryService.getDailyMood(
            state.currentDate.year, state.currentDate.month);
        setScopeData(CalendarMonthViewScopeData(mood, true));
        break;
      case CalendarViewScope.DAILY:
        final diary = await diaryService.getDiary(state.currentDate.year,
            state.currentDate.month, state.currentDate.day, true);
        final dailyScopeData = CalendarDailyViewScopeData(diary, true);
        setScopeData(dailyScopeData);
        extractULIDFromContent(diary.content).forEach((element) {
          final cachedUser = inject<TagResolver>().friendCache[element];
          if(cachedUser != null){
            dailyScopeData.diaryTextController.addUser(cachedUser);
          } else {
            //없으면..
            inject<TagResolver>().getByUserId(element).then((value) {
              if(value != null) {
                setState(() {
                  dailyScopeData.diaryTextController.addUser(value);
                });
              }
            });
          }

        });
        dailyScopeData.focusNode.addListener(() {
          if (isFriendBarOpen) {
            toggleFriendBar();
          }
        });
        dailyScopeData.diaryTextController.addListener(() {
          final _controller = dailyScopeData.diaryTextController;
          final currentTextBlock = _controller.text;
          int startBlockPosition = _controller.selection.baseOffset - 1;
          int endBlockPosition = _controller.selection.baseOffset - 1;
          if(startBlockPosition < 0 || endBlockPosition < 0) return;
          int maxCursorPosition = currentTextBlock.length;
          String currentChar = '';
          while(startBlockPosition > 0 && (currentChar = currentTextBlock[startBlockPosition - 1]) != ' ' && currentChar != '\n') {
            startBlockPosition--;
          }
          while(endBlockPosition >= 0 && endBlockPosition < maxCursorPosition - 1 && (currentChar = currentTextBlock[endBlockPosition + 1]) != ' ' && currentChar != '\n') {
            endBlockPosition++;
          }
          final block = currentTextBlock.substring(startBlockPosition, endBlockPosition + 1);
          if(block.startsWith("@")) {
            setState(() {
              dailyScopeData.tagSelectionStart = startBlockPosition+1;
              dailyScopeData.tagSelectionEnd = endBlockPosition + 1;
            });
          }else {
            if(dailyScopeData.getTagSelectionText() != null) {
              setState(() {
                dailyScopeData.tagSelectionStart = null;
                dailyScopeData.tagSelectionEnd = null;
              });
            }
          }


        });
        break;
    }
  }

  Future<void> applyWithFriendScope(CalendarViewScope scope) async {
    final friend = state.selectedUser;
    if (friend == null) throw Exception();
    switch (scope) {
      case CalendarViewScope.YEAR:
        final mood = await friendDiaryService.getMonthlyMood(
            friend.userId, state.currentDate);
        setScopeData(CalendarYearViewScopeData(mood, false));
        break;
      case CalendarViewScope.MONTH:
        final mood = await friendDiaryService.getDailyMood(
            friend.userId, state.currentDate);
        setScopeData(CalendarMonthViewScopeData(mood, false));
        break;
      case CalendarViewScope.DAILY:
        final diary =
            await friendDiaryService.getDiary(friend.userId, state.currentDate);
        final dailyScopeData = CalendarDailyViewScopeData(
            diary ?? Diary.create(ymd: state.currentDate), false);
        setScopeData(dailyScopeData);
        if (dailyScopeData.isMyScope) {
          dailyScopeData.focusNode.addListener(() {
            if (isFriendBarOpen) {
              toggleFriendBar();
            }
          });
        }
        break;
    }
  }

  Future<void> setScopeData(CalendarScopeData data) async {
    // if ((state.scope == CalendarViewScope.YEAR &&
    //         data is CalendarYearViewScopeData) ||
    //     (state.scope == CalendarViewScope.MONTH &&
    //         data is CalendarMonthViewScopeData) ||
    //     (state.scope == CalendarViewScope.DAILY &&
    //         data is CalendarDailyViewScopeData)) {
    //   state.scopeData = data;
    // }
    state.scopeData = data;
  }

  Widget Function() getRoutedWidgetBuilder() {
    switch (state.scope) {
      case CalendarViewScope.YEAR:
        return () => CalendarYearView();
      case CalendarViewScope.MONTH:
        return () => CalendarMonthView();
      case CalendarViewScope.DAILY:
        return () => CalendarDailyDiaryView();
    }
  }

  void onEditingCompleted() {
    if (state.scope == CalendarViewScope.DAILY &&
        onlineService.isOnlineMode()) {
      final scopeData = state.scopeData as CalendarDailyViewScopeData;
      if (!scopeData.isMyScope) return;
      saveDebouncer.runLastCall(() async {
        final lastDiary = scopeData.currentDiary;
        await diaryService.updateDiary(lastDiary, scopeData.currentMood,
            scopeData.diaryTextController.text, scopeData.imageUrl);
      });
    }
  }

  void unFocusTextField() {
    if (state.scope != CalendarViewScope.DAILY) return;
    final dailyScope = state.scopeData as CalendarDailyViewScopeData;
    dailyScope.focusNode.unfocus();
  }

  void onTextFieldMove(PointerMoveEvent event) {
    if (event.delta.dx.abs() < 15) return;
    dragDebouncer.runLastCall(() {
      final isPositive = event.delta.dx < 0;
      final moveAmount = isPositive ? 1 : -1;
      changeDay(moveAmount);
    });
  }

  void onVerticalDrag(DragEndDetails details) {
    dragDebouncer.runLastCall(() {
      final isPositive = (details.primaryVelocity ?? 0) > 0;
      if (state.scope == CalendarViewScope.DAILY) {
        final dailyScope = state.scopeData as CalendarDailyViewScopeData;
        if (isPositive) {
          if (dailyScope.focusNode.hasFocus) {
            dailyScope.focusNode.unfocus();
          } else {
            onTapDayTitle();
          }
        } else {
          dailyScope.focusNode.requestFocus();
        }
      } else if (state.scope == CalendarViewScope.MONTH) {
        if (isPositive) {
          if (!isFriendBarOpen) {
            setState(() {
              isFriendBarOpen = true;
            });
          } else {
            onTapMonthTitle();
          }
        } else {
          onTapDayBox(state.currentDate.day);
        }
      } else {
        if (isPositive) {
          onTapYearTitle();
        } else {
          onTapMonthBox(state.currentDate.month);
        }
      }
    });
  }

  void onVerticalDragTopBar(DragEndDetails details) {
    dragDebouncer.runLastCall(() {
      final isPositive = (details.primaryVelocity ?? 0) > 0;
      if (!isPositive) {
        if (isFriendBarOpen) {
          setState(() {
            isFriendBarOpen = false;
          });
        }
      }
    });
  }

  void onHorizontalDrag(DragEndDetails details) {
    dragDebouncer.runLastCall(() {
      final isPositive = (details.primaryVelocity ?? 0) < 0;
      final moveAmount = isPositive ? 1 : -1;
      if (state.scope == CalendarViewScope.DAILY) {
        changeDay(moveAmount);
      } else if (state.scope == CalendarViewScope.MONTH) {
        changeMonth(moveAmount);
      } else {
        changeYear(moveAmount);
      }
    });
  }

  Future<void> onTapFriendIcon(User user) async {
    await setStateAsync(() async {
      state.selectedUser = user;
      await setScope(state.scope);
    });
  }

  void setupHorizontalAnimation(bool forward) {
    forwardAction = forward;
    animationStart = true;
  }

  void setupVerticalAnimation(bool forward) {
    verticalForwardAction = forward;
    verticalAnimationStart = true;
  }

  Future<void> navigateToNow() async {
    final now = DateTime.now();
    final before = DateTime(
        state.currentDate.year, state.currentDate.month, state.currentDate.day);
    if (state.currentDate.year == now.year &&
        state.currentDate.month == now.month &&
        state.currentDate.day == now.day) return;
    final after = before.isAfter(now);
    setupHorizontalAnimation(!after);

    setStateAsync(() async {
      state.currentDate = DateTime(now.year, now.month, now.day);
      await setScope(state.scope);
    });
  }

  Future<void> changeDay(int delta) async {
    final now = DateTime.now();
    final afterDelta = DateTime(state.currentDate.year, state.currentDate.month,
        state.currentDate.day + delta);
    if (afterDelta.isAfter(now)) {
      snackNoFuture();
      return;
    }
    setupHorizontalAnimation(delta > 0);
    setStateAsync(() async {
      state.currentDate =
          DateTime(afterDelta.year, afterDelta.month, afterDelta.day);
      await setScope(CalendarViewScope.DAILY);
    });
  }

  Future<void> changeMonth(int delta) async {
    if (state.scopeData is! CalendarMonthViewScopeData) return;

    final afterDelta = state.currentDate.month + delta;
    int targetMonth = state.currentDate.month;
    int targetYear = state.currentDate.year;
    if (afterDelta < 1) {
      targetMonth = 12;
      targetYear -= 1;
    } else if (afterDelta > 12) {
      targetMonth = 1;
      targetYear += 1;
    } else {
      targetMonth = afterDelta;
    }
    setupHorizontalAnimation(delta > 0);

    setStateAsync(() async {
      state.currentDate =
          DateTime(targetYear, targetMonth, state.currentDate.day);
      await setScope(CalendarViewScope.MONTH);
    });
  }

  Future<void> changeYear(int delta) async {
    final targetYear = state.currentDate.year + delta;
    setupHorizontalAnimation(delta > 0);
    setStateAsync(() async {
      state.currentDate =
          DateTime(targetYear, state.currentDate.month, state.currentDate.day);
      await setScope(CalendarViewScope.YEAR);
    });
  }

  Future<void> onTapMonthBox(int month) async {
    setupVerticalAnimation(true);
    setStateAsync(() async {
      state.currentDate =
          DateTime(state.currentDate.year, month, state.currentDate.day);
      await setScope(CalendarViewScope.MONTH);
    });
  }

  Future<void> onTapDayBox(int day) async {
    final now = DateTime.now();
    final target = DateTime(
        state.currentDate.year, state.currentDate.month, day);
    if (target.isAfter(now)) {
      snackNoFuture();
      return;
    }
    setupVerticalAnimation(true);
    setStateAsync(() async {
      state.currentDate =
          DateTime(state.currentDate.year, state.currentDate.month, day);
      await setScope(CalendarViewScope.DAILY);
    });
  }

  Future<void> onTapYearTitle() async {
    //이럼 머야???
    await navigateToNow();
  }

  Future<void> onTapMonthTitle() async {
    setupVerticalAnimation(false);
    setStateAsync(() async {
      await setScope(CalendarViewScope.YEAR);
    });
  }

  Future<void> onTapDayTitle() async {
    setupVerticalAnimation(false);
    setStateAsync(() async {
      await setScope(CalendarViewScope.MONTH);
    });
  }

  void onTapChangeMood() async {
    final data = state.scopeData as CalendarDailyViewScopeData;
    final newMood = await moodChangeDialog(previousMood: data.currentMood);
    if (newMood != null) {
      setState(() {
        data.currentMood = newMood;
      });
    }
  }

  void snackNoFuture() {
    SnackBarUtil.errorSnackBar(
        message: message("message_cannot_move_to_future"));
  }

  void onTapAddFriend() {
    GlobalRoute.rightToLeftRouteTo('/friends/requests');
  }

  void onTapRemoveImage() {
    final scopeData = state.scopeData as CalendarDailyViewScopeData;
    setState(() {
      scopeData.imageUrl = null;
    });
  }

  void onTapApplyFriendTag(User user){
    if(state.scopeData is CalendarDailyViewScopeData) {
      final scopeData = state.scopeData as CalendarDailyViewScopeData;
      if(scopeData.tagSelectionStart == null || scopeData.tagSelectionEnd == null) return;
      setState(() {
        scopeData.diaryTextController.addUser(user);
        final updatedText = replaceSubstringInRange(scopeData.diaryTextController.text, "${user.userId} ", scopeData.tagSelectionStart!, scopeData.tagSelectionEnd!);
        scopeData.tagSelectionStart = null;
        scopeData.tagSelectionEnd = null;
        scopeData.diaryTextController.text = updatedText;
      });
    }
  }

  String replaceSubstringInRange(String originalString, String replacement, int startIndex, int endIndex) {
    if (startIndex < 0 || endIndex > originalString.length) {
      throw ArgumentError("startIndex and endIndex must be within the range of the original string.");
    }

    String firstPart = originalString.substring(0, startIndex);
    String lastPart = originalString.substring(endIndex);

    return "$firstPart$replacement$lastPart";
  }

  List<String> extractULIDFromContent(String text) {
    RegExp regex = RegExp(r"(@\S+)");
    List<String> result = [];

    for (RegExpMatch match in regex.allMatches(text)) {
      final exp = (match.group(0) ?? ' ').substring(1);
      if(HashUtil.isULID(exp)){
        result.add(exp);
      }
    }
    return result;
  }

  bool isDiaryWriteable() {
    final today = DateTime.now();
    final targetDate = state.currentDate;
    final dateDiff = today.difference(targetDate).inDays;
    if(dateDiff < 0 || dateDiff > 2) {
      return false;
    } else {
      return true;
    }
  }
}
