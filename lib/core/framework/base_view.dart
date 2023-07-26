import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:magcloud_app/view/component/splash_overlay.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';

import 'base_action.dart';

abstract class BaseView<V extends BaseView<V, A, S>,
    A extends BaseViewModel<V, A, S>, S> extends StatelessWidget {
  BaseView({super.key}) {
    action = initViewModel();
  }

  bool isInitialLoad = false;

  late A action;

  A initViewModel();

  bool isAutoRemove() => true;

  Color statusBarColor() => Colors.transparent;

  Color navigationBarColor() {
    return Get.context!.theme.colorScheme.background;
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialLoad) {
      isInitialLoad = true;
    } else {
      action.onReloaded();
    }
    return GetBuilder<A>(
      init: action,
      autoRemove: isAutoRemove(),
      dispose: (State state) => action.dispose(),
      didChangeDependencies: (State state) => action.didChangeDependencies(
        state.context,
      ),
      builder: (A action) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: navigationBarColor(),
            statusBarColor: context.theme.colorScheme.onBackground,
            statusBarIconBrightness: Get.isDarkMode ? Brightness.light : Brightness.dark,
            statusBarBrightness: Get.isDarkMode ? Brightness.dark : Brightness.light,
          ),
          child: Stack(
        alignment: Alignment.center,
        children: [
          render(context, action, action.state),
          action.isLoading
              ? Positioned(
                  child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.3),
                ))
              : Container(),
          action.isLoading ? Positioned(child: SplashOverlay()) : Container(),
        ],
      )),
    );
  }

  Widget render(BuildContext context, A action, S state);
}
