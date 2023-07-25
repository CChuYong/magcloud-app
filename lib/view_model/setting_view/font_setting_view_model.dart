import 'package:flutter/cupertino.dart';
import 'package:magcloud_app/core/util/font.dart';

import '../../core/framework/base_action.dart';
import '../../core/util/i18n.dart';
import '../../view/page/settings_view/font_setting_view.dart';

class FontSettingViewState {
  double fontSize = diaryFontSize;
}

class FontSettingViewModel extends BaseViewModel<FontSettingView,
    FontSettingViewModel, FontSettingViewState> {
  FontSettingViewModel() : super(FontSettingViewState());
  TextEditingController controller =
      TextEditingController(text: message('message_font_example_text'));

  @override
  Future<void> initState() async {}

  @override
  void dispose() {
    setDiaryFontSize(state.fontSize);
    controller.dispose();
  }

  void onTapFont(String font) {
    setState(() {
      setDiaryFont(font);
    });
  }

  void onMoveSlider(double nextValue) {
    setState(() {
      state.fontSize = nextValue;
    });
  }
}
