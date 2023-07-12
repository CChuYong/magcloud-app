import '../framework/state_store.dart';

String diaryFont = "KyoboHandWriting2019";
double diaryFontSize = 1.0;
const defaultFontSize = 18.0;
const fontSizeMin = 12.0;
const fontSizeMax = 32.0;

void setDiaryFont(String fontName) {
  diaryFont = fontName;
  StateStore.setString('diaryFont', fontName);
}

void setDiaryFontSize(double fontSize) {
  diaryFontSize = fontSize;
  StateStore.setDouble('diaryFontSize', fontSize);
}
