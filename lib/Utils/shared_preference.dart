import 'package:shared_preferences/shared_preferences.dart';

extension SharedPreferencesExtension on SharedPreferences {
  static const String _defaultKey = 'exampleKey'; // Replace with your preferred key

  Future<void> setSharedPrefStringValue(String value, {String key = _defaultKey}) async {
    await setString(key, value);
  }

  String? getSharedPrefStringValue({String key = _defaultKey}) {
    return getString(key);
  }

  Future<void> setSharedPrefBoolValue(bool value, {String key = _defaultKey}) async {
    await setBool(key, value);
  }

  bool? getSharedPrefBoolValue({String key = _defaultKey}) {
    return getBool(key);
  }

  Future<void> setSharedPrefIntValue(int value, {String key = _defaultKey}) async {
    await setInt(key, value);
  }

  int? getSharedPrefIntValue({String key = _defaultKey}) {
    return getInt(key);
  }

  Future<void> clearSharedPrefAllData() async {
    await clear();
  }
}