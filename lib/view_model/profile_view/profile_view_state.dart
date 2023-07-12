import 'package:magcloud_app/core/model/user.dart';
import 'package:quiver/collection.dart';

import '../../core/model/feed_element.dart';

class ProfileViewState {
  User user;
  TreeSet<FeedElement> feeds = TreeSet<FeedElement>(comparator: (a, b) {
    return b.diaryId.compareTo(a.diaryId);
  });

  ProfileViewState({required this.user});
}
