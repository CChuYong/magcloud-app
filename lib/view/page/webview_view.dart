import 'package:flutter/cupertino.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/framework/base_view.dart';
import '../../view_model/webview_view/webview_screen_store.dart';

class WebViewScreenView extends BaseView<WebViewScreenView, WebViewScreenAction,
    WebViewScreenState> {
  final String initialUrl;

  WebViewScreenView(this.initialUrl, {super.key});

  @override
  Widget render(BuildContext context, WebViewScreenAction action,
      WebViewScreenState state) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: context.theme.colorScheme.background,
        child: SafeArea(
          child: WebViewWidget(
            controller: action.webViewController,
          ),
        ));
  }

  @override
  WebViewScreenAction initViewModel() => WebViewScreenAction(initialUrl);
}
