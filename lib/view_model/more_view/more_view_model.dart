import 'package:magcloud_app/core/framework/base_action.dart';
import 'package:magcloud_app/view_model/more_view/more_view_state.dart';

import '../../view/page/more_view.dart';


class MoreViewModel extends BaseViewModel<MoreView, MoreViewModel, MoreViewState> {
  MoreViewModel() : super(MoreViewState());

  @override
  Future<void> initState() async {

  }

}
