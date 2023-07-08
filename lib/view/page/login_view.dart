import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/core/util/i18n.dart';
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
      backgroundColor: BaseColor.defaultSplashBackgroundColor,
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
                                  color: BaseColor.warmGray800,
                                  fontSize: 12.sp,
                                  fontFamily: 'GmarketSans'),
                            ),
                            Text(
                              message("magcloud"),
                              style: TextStyle(
                                  color: BaseColor.warmGray800,
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
                                    Icon(Icons.language),
                                    SizedBox(width: 3.sp),
                                    Text(isKorea ? 'KOR' : 'ENG')
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
                    TouchableOpacity(
                        onTap: action.onAppleLogin,
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.sp),
                              color: Colors.black,
                            ),
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 14.sp),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(children: [
                                    Image.asset('assets/images/apple_23px.png',
                                        height: 21.sp, width: 21.sp),
                                    SizedBox(width: 12.sp),
                                    Text(
                                      message('generic_login_with_apple'),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Pretendard',
                                        fontSize: 18.sp,
                                      ),
                                    )
                                  ])
                                ],
                              ),
                            ))),
                    SizedBox(height: 8.sp),
                    TouchableOpacity(
                        onTap: action.onGoogleLogin,
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.sp),
                              color: Colors.white,
                            ),
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 14.sp),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(children: [
                                    Image.asset('assets/images/google_23px.png',
                                        height: 21.sp, width: 21.sp),
                                    SizedBox(width: 12.sp),
                                    Text(
                                      message('generic_login_with_google'),
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 18.sp,
                                      ),
                                    )
                                  ])
                                ],
                              ),
                            ))),
                    SizedBox(height: 4.sp),
                  ],
                )
              ]),
        ),
      )),
    );
  }
}
