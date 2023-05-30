import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:shared_preferences/shared_preferences.dart';

part 'local_storage_provider.g.dart';

@riverpod
class LocalStorage extends _$LocalStorage {
  late final SharedPreferences prefs;
  @override
  FutureOr<SharedPreferences> build() async {
    final Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    return prefs0;
  }

  Future<bool> setInt(String key, int value) async {
    return prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    return prefs.getInt(key);
  }

  Future<bool> setString(String key, String value) async {
    return prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    return prefs.getString(key);
  }
}
