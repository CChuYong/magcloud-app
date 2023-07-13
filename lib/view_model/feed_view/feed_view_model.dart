import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:magcloud_app/core/api/open_api.dart';
import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/core/model/feed_element.dart';
import 'package:magcloud_app/core/model/navigate_detail.dart';
import 'package:magcloud_app/core/util/debouncer.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/view/page/feed_view.dart';

import '../../core/service/auth_service.dart';
import '../../global_routes.dart';
import '../../view/navigator_view.dart';
import '../../view/page/profile_view.dart';
import '../calendar_view/calendar_base_view_model.dart';
import 'feed_view_state.dart';

class FeedViewModel
    extends BaseViewModel<FeedView, FeedViewModel, FeedViewState> {
  final NavigatorViewState navigator;
  final AuthService authService = inject<AuthService>();
  final OpenAPI openAPI = inject<OpenAPI>();

  FeedViewModel(this.navigator) : super(FeedViewState()) {
    navigator.onTapSelf = onTapNavigatorSelf;
    scrollController.addListener(() {
      final current = scrollController.position.pixels;
      final max = scrollController.position.maxScrollExtent;
      if (current > 0 &&
          current < max &&
          scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
        if (current / max * 100 > 50) {
          scrollDebouncer.runLastCall(() {
            setStateAsync(() async {
              await loadForward();
            });
          });
        }
      }
    });
  }

  bool isMe(String userId) => authService.initialUser?.userId == userId;

  final ScrollController scrollController = ScrollController();
  final Debouncer scrollDebouncer = Debouncer(Duration(milliseconds: 450));

  @override
  Future<void> initState() async {
    await loadForward();
  }

  void navigateToWritePage() {
    CalendarBaseViewModel.navigateToMyPage = true;
    navigator.onTap(1);
  }

  void onTapNavigateToDetail(FeedElement details) async {
    final user = await inject<OpenAPI>().getUserProfile(details.userId);
    CalendarBaseViewModel.nextNavigateDiary = NavigateDetail(user.toDomain(), details.ymd);
    navigator.onTap(1);
  }

  void onTapNavigatorSelf() {
    scrollController.animateTo(0,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void onTapLike(FeedElement element) async {
    await setStateAsync(() async {
      final result = await openAPI.likeDiary(element.diaryId);
      state.feeds.remove(element);
      state.feeds.add(result.toDomain());
    });
  }

  void onTapUnlike(FeedElement element) async {
    await setStateAsync(() async {
      final result = await openAPI.unlikeDiary(element.diaryId);
      state.feeds.remove(element);
      state.feeds.add(result.toDomain());
    });
  }

  Future<void> loadForward() async {
    if (state.feeds.isEmpty) {
      final feeds = await inject<OpenAPI>().getFeeds(state.size);
      state.feeds.addAll(feeds.map((e) => e.toDomain()));
    } else {
      final oldestEntry = state.feeds.last;
      final feeds = await inject<OpenAPI>()
          .getFeedsWithId(state.size, oldestEntry.diaryId);
      state.feeds.addAll(feeds.map((e) => e.toDomain()));
    }
  }

  Future<void> refreshFullPage() async {
    return setStateAsync(() async {
      state.feeds.clear();
      await loadForward();
    });
  }

  @override
  void onReloaded() {
    setStateAsync(() async {
      await initState();
    });
  }

  void onTapProfileImage(String userId) async {
    final user = await inject<OpenAPI>().getUserProfile(userId);
    route() => ProfileView(user.toDomain(), isMe(userId), true);
    GlobalRoute.rightToLeftRouteToDynamic(route);
  }
}
