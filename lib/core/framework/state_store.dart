import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../util/i18n.dart';

class StateStore {
  static Future<SharedPreferences> get _instance async =>
      sharedPreferences ??= await SharedPreferences.getInstance();
  static SharedPreferences? sharedPreferences;

  static Future<SharedPreferences> init() async {
    sharedPreferences = await _instance;
    isKorea = sharedPreferences!.getBool('isKorea') ?? true;
    return sharedPreferences!;
  }

  static void saveState(Type key, Map<String, dynamic> state) async {
    try {
      print('saving state with ${key.toString()} as ${jsonEncode(state)}');
      await sharedPreferences!.setString(key.toString(), jsonEncode(state));
    } catch (e) {
      print(e);
    }
  }

  static Map<String, dynamic>? loadState(Type key) {
    final data = sharedPreferences!.getString(key.toString());
    if (data == null) return null;
    return jsonDecode(data);
  }

  static void clear(String key) {
    sharedPreferences!.remove(key.toString());
  }

  static void clearAll() {
    sharedPreferences!.clear();
  }

  static void setString(String key, String value) async {
    await sharedPreferences!.setString(key, value);
  }

  static String? getString(String key) => sharedPreferences!.getString(key);

  static void setBool(String key, bool value) async {
    await sharedPreferences!.setBool(key, value);
  }

  static bool getBool(String key, bool def) => sharedPreferences!.getBool(key) ?? def;

  static void setInt(String key, int value) async {
    await sharedPreferences!.setInt(key, value);
  }

  static int? getInt(String key) => sharedPreferences!.getInt(key);
}
