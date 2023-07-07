import 'package:magcloud_app/core/util/i18n.dart';
import 'package:magcloud_app/view/page/settings_view/language_setting_view.dart';

import '../../core/framework/base_action.dart';

class LanguageSettingViewState {}

class LanguageSettingViewModel extends BaseViewModel<LanguageSettingView,
    LanguageSettingViewModel, LanguageSettingViewState> {
  LanguageSettingViewModel() : super(LanguageSettingViewState());

  @override
  Future<void> initState() async {}

  void onLanguageTap(bool korea) {
    if (korea == isKorea) return;
    setState(() {
      setLanguage(korea);
    });
  }
}
