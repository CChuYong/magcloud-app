import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:magcloud_app/core/framework/base_view.dart';

import '../../view_model/friend_view/friend_view_model.dart';
import '../../view_model/friend_view/friend_view_state.dart';
import '../component/navigation_bar.dart';
import '../designsystem/base_color.dart';

class FriendView extends BaseView<FriendView, FriendViewModel, FriendViewState> {
  const FriendView({super.key});

  @override
  FriendViewModel initViewModel() => FriendViewModel();

  @override
  Widget render(BuildContext context, FriendViewModel action, FriendViewState state) {
    return Scaffold(
      backgroundColor: BaseColor.defaultBackgroundColor,
      bottomNavigationBar: BaseNavigationBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          ],
        ),
      ),
    );
  }

}