import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'base_action.dart';

abstract class BaseView<V extends BaseView<V, A, S>,
    A extends BaseViewModel<V, A, S>, S> extends StatelessWidget {
  const BaseView({super.key});

  A initViewModel();

  @override
  Widget build(BuildContext context) {
    A action = initViewModel();
    return GetBuilder<A>(
      init: action,
      dispose: (State state) => action.dispose(),
      didChangeDependencies: (State state) => action.didChangeDependencies(
        state.context,
      ),
      builder: (A action) => WillPopScope(
        child: Stack(
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
        onWillPop: () => action.onWillPop(),
      ),
    );
  }

  Widget render(BuildContext context, A action, S state);
}
