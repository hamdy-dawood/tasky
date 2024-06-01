import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> put({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) {
      return await _prefs!.setString(key, value);
    } else if (value is bool) {
      return await _prefs!.setBool(key, value);
    } else if (value is double) {
      return await _prefs!.setDouble(key, value);
    } else {
      return await _prefs!.setInt(key, value);
    }
  }

  static dynamic get({
    required String key,
  }) {
    return _prefs!.get(key);
  }

  static Future<bool> removeData({required key}) async {
    return await _prefs!.remove(key);
  }

  static Future<bool> clear() async {
    try {
      return await _prefs?.clear() ?? false;
    } catch (e) {
      return false;
    }
  }
}
