import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:magcloud_app/core/api/open_api.dart';
import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/core/model/user.dart';
import 'package:magcloud_app/core/util/debouncer.dart';
import 'package:magcloud_app/di.dart';
import 'package:magcloud_app/view/page/feed_view.dart';

import '../../global_routes.dart';
import '../../view/page/profile_view.dart';
import 'feed_view_state.dart';

class FeedViewModel extends BaseViewModel<FeedView, FeedViewModel, FeedViewState> {
  FeedViewModel() : super(FeedViewState()) {
    scrollController.addListener(() {
      final current = scrollController.position.pixels;
      final max = scrollController.position.maxScrollExtent;
      if(current > 0 && current < max && scrollController.position.userScrollDirection == ScrollDirection.reverse){
        if(current / max * 100 > 50) {
          scrollDebouncer.runLastCall(() {
            loadForward();
          });
        }
      }
    });

  }

  final ScrollController scrollController = ScrollController();
  final Debouncer scrollDebouncer = Debouncer(Duration(milliseconds: 500));

  @override
  Future<void> initState() async {
    await loadForward();
  }

  Future<void> loadForward() async {
    if(state.feeds.isEmpty) {
      final feeds = await inject<OpenAPI>().getFeeds(state.size);
      state.feeds.addAll(feeds.map((e) => e.toDomain()));
    } else {
      final oldestEntry = state.feeds.last;
      final feeds = await inject<OpenAPI>().getFeedsWithId(state.size, oldestEntry.diaryId);
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
    route() => ProfileView(user.toDomain(), false);
    GlobalRoute.rightToLeftRouteToDynamic(route);
  }
}
