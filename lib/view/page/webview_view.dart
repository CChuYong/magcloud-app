import 'package:flutter/cupertino.dart';
import 'package:magcloud_app/view/designsystem/base_color.dart';
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
        color: BaseColor.defaultBackgroundColor,
        child: SafeArea(
          child: WebViewWidget(
            controller: action.webViewController,
          ),
        ));
  }

  @override
  WebViewScreenAction initViewModel() => WebViewScreenAction(initialUrl);
}
