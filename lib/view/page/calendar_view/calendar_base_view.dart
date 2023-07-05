import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:magcloud_app/core/framework/base_view.dart';

import '../../../view_model/calendar_view/calendar_base_view_model.dart';
import '../../../view_model/calendar_view/calendar_base_view_state.dart';
import '../../component/navigation_bar.dart';
import '../../designsystem/base_color.dart';

class CalendarBaseView extends BaseView<CalendarBaseView, CalendarBaseViewModel, CalendarBaseViewState> {
  const CalendarBaseView({super.key});

  @override
  CalendarBaseViewModel initViewModel() => CalendarBaseViewModel();

  @override
  Widget render(BuildContext context, CalendarBaseViewModel action, CalendarBaseViewState state) {
    return Scaffold(
      backgroundColor: BaseColor.defaultBackgroundColor,
      bottomNavigationBar: BaseNavigationBar(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: action.getRoutedWidgetBuilder()(),
      ),
    );
  }

}
