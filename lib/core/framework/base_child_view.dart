import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'base_action.dart';
import 'base_view.dart';

abstract class BaseChildView<V extends BaseView<V, A, S>,
    A extends BaseViewModel<V, A, S>, S> extends StatelessWidget {
  BaseChildView({super.key});

  Widget render(BuildContext context, A action, S state);

  final A action = Get.find<A>();

  @override
  Widget build(BuildContext context) {
    return render(context, action, action.state);
  }
}
