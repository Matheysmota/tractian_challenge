import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  Future<bool> setJsonModel<T>({
    required String key,
    required Map<String, dynamic> Function(T model) toJson,
    required T value,
  });

  Future<T?> getJson<T>({
    required String key,
    required T Function(Map<String, dynamic> model) mapper,
    T? defaultValue,
  });

  Future<void> remove(String key);

  Future<void> clear();
}

class LocalStorageImpl implements LocalStorage {
  const LocalStorageImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<void> clear() {
    return _prefs.clear();
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<bool> setJsonModel<T>({
    required String key,
    required Map<String, dynamic> Function(T model) toJson,
    required T value,
  }) async {
    try {
      final mappedModel = toJson(value);
      await _prefs.setString(key, json.encode(mappedModel));
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<T?> getJson<T>({
    required String key,
    required T Function(Map<String, dynamic> map) mapper,
    T? defaultValue,
  }) async {
    try {
      final jsonString = _prefs.getString(key);
      if (jsonString == null) {
        return defaultValue;
      }
      return mapper(json.decode(jsonString) as Map<String, dynamic>);
    } catch (e) {
      return defaultValue;
    }
  }
}
