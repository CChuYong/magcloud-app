

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/view/component/touchableopacity.dart';
import 'package:magcloud_app/view/designsystem/base_icon.dart';
import 'package:magcloud_app/view_model/more_view/more_view_model.dart';
import 'package:magcloud_app/view_model/more_view/more_view_state.dart';

import '../../core/util/i18n.dart';
import '../designsystem/base_color.dart';

class MoreView extends BaseView<MoreView, MoreViewModel, MoreViewState> {
  MoreView({super.key});

  @override
  bool isAutoRemove() => false;

  @override
  MoreViewModel initViewModel() => MoreViewModel();

  @override
  Color navigationBarColor() => BaseColor.warmGray100;

  @override
  Widget render(
      BuildContext context, MoreViewModel action, MoreViewState state) {
    final ScrollController controller = ScrollController();
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.sp),
          titleBar(context),
          SizedBox(height: 20.sp),
          Expanded(child:
          ShaderMask(
              shaderCallback: (Rect rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
                  stops: [0.0, 0.0, 0.95, 1.0], // 10% purple, 80% transparent, 10% purple
                ).createShader(rect);
              },
              blendMode: BlendMode.dstOut,
              child:Scrollbar(
            controller: controller,
          child: ListView(
              controller: controller,
          children: [
            meBox(context, action, state),
            SizedBox(height: 15.sp),
            menuBox(context, action)
            ])
          ))),



        ],
      ),
    );
  }

  Widget titleBar(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              message('navigation_more'),
              style: TextStyle(
                  color: context.theme.colorScheme.primary,
                  fontSize: 22.sp,
                  fontFamily: 'GmarketSans'),
            ),
          ],
        ));
  }

  Widget meBox(BuildContext context, MoreViewModel action, MoreViewState state) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: TouchableOpacity(
            onTap: action.onTapMyProfiles,
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.onBackground,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: BaseColor.warmGray400.withOpacity(0.3),
                      spreadRadius: 0.5,
                      blurRadius: 10,
                      offset: const Offset(3, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 14.sp, horizontal: 14.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50.sp,
                            height: 50.sp,
                            decoration: BoxDecoration(
                                image: state.me != null
                                    ? DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            state.me!.profileImageUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                color: BaseColor.defaultBackgroundColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: BaseColor.warmGray300, width: 0.5)),
                          ),
                          SizedBox(width: 13.sp),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.me?.name ?? '',
                                style: TextStyle(
                                    color:  context.theme.colorScheme.primary,
                                    fontSize: 16.sp,
                                    fontFamily: 'Pretendard'),
                              ),
                              Text(
                                state.me?.nameTag ?? '',
                                style: TextStyle(
                                    color:  context.theme.colorScheme.secondary,
                                    fontSize: 12.sp,
                                    fontFamily: 'Pretendard'),
                              ),
                            ],
                          )
                        ],
                      ),
                      Icon(BaseIcon.arrowRight, color: context.theme.colorScheme.secondary)
                    ],
                  ),
                ))));
  }

  Widget menuBox(BuildContext context, MoreViewModel action) {
    final boxGap = 10.sp;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.sp),
              Text(
                message('menu_settings'),
                style: TextStyle(
                    color: context.theme.colorScheme.primary,
                    fontSize: 18.sp,
                    fontFamily: 'Pretendard'),
              ),
              // SizedBox(height: boxGap),
              // menuBtn(Icons.person, message('menu_my_profiles'), action.onTapMyProfiles),
              SizedBox(height: boxGap),
              menuBtn(Icons.notifications, message('menu_notification'),
                  action.onTapNotification),
              menuBtn(Icons.font_download, message('menu_fonts'),
                  action.onTapFonts),
              menuBtn(Icons.language, message('menu_language'),
                  action.onTapLanguage),
              menuBtn(Icons.dark_mode_outlined, message('menu_dark_mode'),
                  action.onTapDarkMode),
              SizedBox(height: 18.sp),
              Text(
                message('menu_info'),
                style: TextStyle(
                    color: context.theme.colorScheme.primary,
                    fontSize: 18.sp,
                    fontFamily: 'Pretendard'),
              ),
              SizedBox(height: boxGap),
              menuBtn(Icons.newspaper_outlined, message('menu_notice'),
                  action.onTapNotice),
              menuBtn(Icons.file_copy_rounded, message('menu_privacy'),
                  action.onTapPrivacy),
              menuBtn(Icons.phone_android, message('menu_app_info'),
                  action.onTapAppInfo),
              menuBtn(Icons.support_agent_sharp, message('generic_contact_to_developer'), action.onTapContact),
              menuBtn(Icons.person_off, message('menu_user_quit'), action.leave),
              menuBtn(Icons.logout, message('menu_logout'), action.logout),
              SizedBox(height: 18.sp),
            ],
          ),
        );
  }

  final boxPadding = 5.sp;

  Widget menuBtn(IconData icon, String name, void Function() onTap) {
    BuildContext context = Get.context!;
    final iconSize = 19.sp;
    return TouchableOpacity(
        onTap: onTap,
        child: Column(children: [
          Container(
              //color: BaseColor.orange300,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 11.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: iconSize,
                            width: iconSize,
                            child: Center(
                                child: Icon(icon,
                                    size: iconSize,
                                    color: context.theme.colorScheme.primary)),
                          ),
                          SizedBox(width: 12.sp),
                          Text(
                            name,
                            style: TextStyle(
                                color: context.theme.colorScheme.primary,
                                fontSize: 15.sp,
                                height: 1.2,
                                fontFamily: 'Pretendard'),
                          ),
                        ],
                      ),
                      Icon(BaseIcon.arrowRight,
                          color: context.theme.colorScheme.secondary, size: 14.sp)
                    ],
                  )))
        ]));
  }
}
