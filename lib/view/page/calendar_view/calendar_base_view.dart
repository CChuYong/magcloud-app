import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/core/framework/base_view.dart';

import '../../../core/util/i18n.dart';
import '../../../view_model/calendar_view/calendar_base_view_model.dart';
import '../../../view_model/calendar_view/calendar_base_view_state.dart';
import '../../component/navigation_bar.dart';
import '../../designsystem/base_color.dart';

class CalendarBaseView extends BaseView<CalendarBaseView, CalendarBaseViewModel,
    CalendarBaseViewState> {
  const CalendarBaseView({super.key});

  @override
  CalendarBaseViewModel initViewModel() => CalendarBaseViewModel();

  @override
  Widget render(BuildContext context, CalendarBaseViewModel action,
      CalendarBaseViewState state) {
    return Scaffold(
      backgroundColor: BaseColor.defaultBackgroundColor,
      bottomNavigationBar: BaseNavigationBar(),
      body: SafeArea(
        child: Column(
          children: [
            titleBar(),
            SizedBox(height: 18.sp),
            friendBar(),
            Divider(),
            Expanded(
                child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: action.getRoutedWidgetBuilder()(),
            )),
          ],
        ),
      ),
    );
  }

  Widget titleBar() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              message("magcloud"),
              style: TextStyle(
                  color: BaseColor.warmGray800,
                  fontSize: 22.sp,
                  fontFamily: 'GmarketSans'),
            ),
            Icon(Icons.notifications_none_rounded, size: 22.sp),
          ],
        ));
  }

  Widget friendBar() {
    return Container(
      width: double.infinity,
      height: 64.sp,
      child: CustomScrollView(scrollDirection: Axis.horizontal, slivers: [
        SliverToBoxAdapter(child: SizedBox(width: 15.sp)),
        for (int i = 0; i < 10; i++) ...[
          SliverToBoxAdapter(child: friendIcon()),
          SliverToBoxAdapter(child: SizedBox(width: 10.sp)),
        ],
        SliverToBoxAdapter(child: SizedBox(width: 15.sp)),
      ]),
    );
  }

  Widget friendIcon() {
    return Column(
      children: [
        Container(
          width: 42.sp,
          height: 42.sp,
          decoration: BoxDecoration(
              color: BaseColor.warmGray700,
              shape: BoxShape.circle,
              border: Border.all(color: BaseColor.red300, width: 2.0)),
        ),
        Text(
          '송영민',
          style: TextStyle(
            color: BaseColor.warmGray500,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
