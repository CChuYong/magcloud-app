import 'package:flutter/material.dart';

final class BaseColor {
// static const warmGray900 = Color(0xff1C1917);
  static const warmGray800 = Color(0xff292524);
  static const warmGray700 = Color(0xff44403C);
  static const warmGray600 = Color(0xff57534E);
  static const warmGray500 = Color(0xff78716C);
  static const warmGray400 = Color(0xffA8A29E);
  static const warmGray300 = Color(0xffD6D3D1);
  static const warmGray200 = Color(0xffE7E5E4);
  static const warmGray100 = Color(0xffF5F5F4);
  static const warmGray50 = Color(0xffFAFAF9);

//static const green900 = Color(0xff14532D);
// static const green800 = Color(0xff166534);
// static const green700 = Color(0xff15803D);
  static const green600 = Color(0xff16A34A);
// static const green500 = Color(0xff22C55E);
  static const green400 = Color(0xff4ADE80);
  static const green300 = Color(0xff86EFAC);
  static const green200 = Color(0xffBBF7D0);
  static const green100 = Color(0xffDCFCE7);
  static const green50 = Color(0xffF0FDF4);

  static const red300 = Color(0xffFCA5A5);
  static const red400 = Color(0xffF87171);
  static const yellow300 = Color(0xffFCD34D);
  static const orange300 = Color(0xffFDBA74);
  static const blue300 = Color(0xff93C5FD);

  static const defaultBackgroundColor = Colors.white;
  static const defaultSplashBackgroundColor = warmGray200;
}

final class DarkBaseColor {
  static const defaultBackgroundColor = Colors.black;
  static const defaultSplashBackgroundColor = BaseColor.warmGray800;
}
