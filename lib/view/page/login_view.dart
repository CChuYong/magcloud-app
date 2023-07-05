import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magcloud_app/core/framework/base_view.dart';
import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/view_model/login_view/login_view_model.dart';

import '../../view_model/login_view/login_view_state.dart';
import '../component/touchableopacity.dart';
import '../designsystem/base_color.dart';

class LoginView extends BaseView<LoginView, LoginViewModel, LoginViewState> {
  @override
  LoginViewModel initViewModel() => LoginViewModel();

  @override
  Widget render(
      BuildContext context, LoginViewModel action, LoginViewState state) {
    return Scaffold(
      backgroundColor: BaseColor.warmGray200,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 19.sp, vertical: 18.sp),
          child: Column(
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
                Column(
                  children: [
                    TouchableOpacity(
                        onTap: action.onAppleLogin,
                        child: Image.asset(
                            'assets/images/sign_in_with_apple_4x.png')),
                    SizedBox(height: 8.sp),
                    TouchableOpacity(
                      onTap: action.onGoogleLogin,
                      child: Image.asset(
                          'assets/images/sign_in_with_google_4x.png'),
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
