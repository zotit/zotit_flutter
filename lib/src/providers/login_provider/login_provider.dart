import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zotit_flutter/src/screens/login/login_model.dart';
import 'package:http/http.dart' as http;

part 'login_provider.g.dart';

// @riverpod
// Future<LoginData> getLoginData(GetLoginDataRef ref) async {
//   final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
//   final prefs = await fPrefs;
//   final token = prefs.getString('token');
//   return LoginData(token: token ?? "");
// }

@riverpod
class LoginToken extends _$LoginToken {
  @override
  FutureOr<LoginData> build() async {
    return _loadToken();
  }

  Future<LoginData> _loadToken() async {
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    final token = prefs.getString('token');
    final username = prefs.getString('username') ?? "";
    return LoginData(token: token ?? "", error: "", username: username);
  }

  Future<void> setToken(String token) async {
    state = const AsyncLoading();
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    await prefs.setString('token', token);
    final loginData = await _loadToken();
    state = AsyncData(loginData);
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    await prefs.clear();
    final loginData = await _loadToken();
    state = AsyncData(loginData);
  }

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    state = await AsyncValue.guard(() async {
      final uri = Uri.https('zotit.twobits.in', '/login');
      final res = await http.post(uri, body: {
        "username": username,
        "password": password,
      });
      if (res.body == "\"user not found\"") {
        state = AsyncError(res.body, StackTrace.current);
        return LoginData(token: "", error: res.body, username: '');
      }
      if (res.body == "{}") {
        state = AsyncError(res.body, StackTrace.current);
        return LoginData(token: "", error: "\"user not found\"", username: '');
      }

      final resData = jsonDecode(res.body);
      prefs.setString("token", resData["token"]!);
      prefs.setString("username", username);
      return _loadToken();
    });
  }

  Future<void> register(String username, String password) async {
    state = const AsyncLoading();
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    state = await AsyncValue.guard(() async {
      final uri = Uri.https('zotit.twobits.in', '/register');
      final res = await http.post(uri, body: {
        "username": username,
        "password": password,
      });
      if (res.body == "\"username taken\"") {
        state = AsyncError(res.body, StackTrace.current);
        return LoginData(token: "", error: res.body, username: '');
      }
      final resData = jsonDecode(res.body);
      prefs.setString("token", resData["token"]!);
      prefs.setString('username', username);
      return _loadToken();
    });
  }

  getData() {
    return state.value;
  }
}