import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

extension JsonMethods on SharedPreferences {
  Future<bool> setJson(String key, Map<String, dynamic> json) async {
    bool result = await setString(key, jsonEncode(json));
    return result;
  }

  Map<String, dynamic>? getJson(String key) {
    String? storedJson = getString(key)
    ;
    if (storedJson == null) return null;

    Map<String, dynamic> parsedStoredJson = jsonDecode(storedJson) as Map<String, dynamic>;
    return parsedStoredJson;
  }
}