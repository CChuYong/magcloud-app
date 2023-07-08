import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
