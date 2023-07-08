import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
  Color navigationBarColor() => BaseColor.defaultBackgroundColor;

  @override
  Widget build(BuildContext context) {
    action.setBottomColor(navigationBarColor());
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
      builder: (A action) => Stack(
        children: [
          render(context, action, action.state),
          action.isLoading
              ? Positioned(
                  child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.1),
                ))
              : Container(),
        ],
      ),
    );
  }

  Widget render(BuildContext context, A action, S state);
}
