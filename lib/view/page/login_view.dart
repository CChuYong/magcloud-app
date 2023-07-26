import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/global_routes.dart';
import 'package:magcloud_app/view/component/fadeable_switcher.dart';
import 'package:magcloud_app/view_model/login_view/login_view_model.dart';

import '../../view_model/login_view/login_view_state.dart';
import '../component/touchableopacity.dart';
import '../designsystem/base_color.dart';

class LoginView extends BaseView<LoginView, LoginViewModel, LoginViewState> {
  @override
  LoginViewModel initViewModel() => LoginViewModel();

  @override
  Color navigationBarColor() => BaseColor.defaultSplashBackgroundColor;

  @override
  Widget render(
      BuildContext context, LoginViewModel action, LoginViewState state) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      body: SafeArea(
          child: Fadeable(
        child: Padding(
          key: Key(isKorea.toString()),
          padding: EdgeInsets.symmetric(horizontal: 19.sp, vertical: 18.sp),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message("message_login_view_description"),
                              style: TextStyle(
                                  color: context.theme.colorScheme.secondary,
                                  fontSize: 12.sp,
                                  fontFamily: 'GmarketSans'),
                            ),
                            Text(
                              message("magcloud"),
                              style: TextStyle(
                                  color: context.theme.colorScheme.primary,
                                  fontSize: 30.sp,
                                  fontFamily: 'GmarketSans'),
                            ),
                          ],
                        ),
                        TouchableOpacity(
                            onTap: action.toggleLanguage,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: BaseColor.warmGray100,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.sp, horizontal: 6.sp),
                                child: Row(
                                  children: [
                                    Icon(Icons.language,    color: BaseColor.warmGray700,),
                                    SizedBox(width: 3.sp),
                                    Text(isKorea ? 'KOR' : 'ENG', style: TextStyle(
                                      color: BaseColor.warmGray700,
                                    ))
                                  ],
                                ),
                              ),
                            ))
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      message('generic_social_login'),
                      style: TextStyle(
                          color: context.theme.colorScheme.primary,
                          fontSize: 14.sp,
                          fontFamily: 'GmarketSans'),
                    ),
                    SizedBox(height: 10.sp),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TouchableOpacity(
                                  onTap: action.onKakaoLogin,
                                  child: Container(
                                      width: 50.sp,
                                      height: 50.sp,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffFEE500),
                                      ),
                                      child: Image.asset('assets/images/kakao.png', height: 25.sp, width: 25.sp, fit: BoxFit.contain))),
                              SizedBox(width: 15.sp),
                              Platform.isIOS ?
                              Row(
                                children: [
                                  TouchableOpacity(
                                      onTap: action.onAppleLogin,
                                      child: Container(
                                          width: 50.sp,
                                          height: 50.sp,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black,
                                          ),
                                          child: Image.asset('assets/images/apple_23px.png',
                                              height: 25.sp, width: 25.sp))),
                                  SizedBox(width: 15.sp),
                                ],
                              )
                                  : Container(),
                              TouchableOpacity(
                                  onTap: action.onGoogleLogin,
                                  child: Container(
                                      width: 50.sp,
                                      height: 50.sp,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Image.asset('assets/images/google_23px.png',
                                          height: 25.sp, width: 25.sp))),
                            ],
                          )]),
                    SizedBox(height: 10.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          message('message_login_privacy_1'),
                          style: TextStyle(
                              color: context.theme.colorScheme.primary,
                              fontSize: 12.sp,
                              fontFamily: 'GmarketSans'),
                        ),
                        TouchableOpacity(
                          onTap: () => GlobalRoute.privacyPage(),
                          child: Text(
                            message('message_login_privacy_2'),
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: context.theme.colorScheme.secondary,
                                color: context.theme.colorScheme.primary,
                                fontSize: 12.sp,
                                fontFamily: 'GmarketSans'),
                          )
                        ),
                        Text(
                          message('message_login_privacy_3'),
                          style: TextStyle(
                              color: context.theme.colorScheme.primary,
                              fontSize: 12.sp,
                              fontFamily: 'GmarketSans'),
                        ),
                      ],
                    )

                  ],
                )

              ]),
        ),
      )),
    );
  }
}
