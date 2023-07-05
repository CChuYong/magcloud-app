import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/view_model/more_view/more_view_model.dart';
import 'package:magcloud_app/view_model/more_view/more_view_state.dart';

import '../../view_model/friend_view/friend_view_model.dart';
import '../../view_model/friend_view/friend_view_state.dart';
import '../component/navigation_bar.dart';
import '../designsystem/base_color.dart';

class MoreView extends BaseView<MoreView, MoreViewModel, MoreViewState> {
  const MoreView({super.key});

  @override
  MoreViewModel initViewModel() => MoreViewModel();

  @override
  Widget render(BuildContext context, MoreViewModel action, MoreViewState state) {
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
