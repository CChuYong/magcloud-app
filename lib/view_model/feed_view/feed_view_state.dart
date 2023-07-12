import 'package:quiver/collection.dart';

import '../../core/model/feed_element.dart';

class FeedViewState {
  TreeSet<FeedElement> feeds = TreeSet<FeedElement>(comparator: (a, b) {
    return b.diaryId.compareTo(a.diaryId);
  });
  int size = 10;
}
