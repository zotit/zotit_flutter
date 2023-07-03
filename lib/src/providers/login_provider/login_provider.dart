import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zotit/config.dart';
import 'package:zotit/src/screens/login/login_model.dart';
import 'package:http/http.dart' as http;

part 'login_provider.g.dart';

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
    final page = prefs.getString('page') ?? "";
    return LoginData(token: token ?? "", error: "", username: username, page: page);
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
      final config = Config();
      final uri = Uri(scheme: config.scheme, host: config.host, port: config.port, path: "api/login");
      final res = await http.post(uri,
          body: jsonEncode({
            "username": username,
            "password": password,
          }),
          headers: {"Content-Type": "application/json"});

      try {
        final resData = jsonDecode(res.body);

        prefs.setString("token", resData["token"]!);
        prefs.setString("username", username);

        if (!resData['is_active']) {
          prefs.setString("page", 'resetpw');
          return _loadToken();
        }
        prefs.remove("page");
        return _loadToken();
      } catch (e) {
        return LoginData(token: "", error: res.body.replaceAll("\"", ""), username: '', page: '');
      }
    });
  }

  Future<void> forgotpw(
    String username,
  ) async {
    state = const AsyncLoading();
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    state = await AsyncValue.guard(() async {
      final config = Config();
      final uri = Uri(scheme: config.scheme, host: config.host, port: config.port, path: "api/forgotpw");
      final res = await http.post(uri,
          body: jsonEncode({
            "username": username,
          }),
          headers: {"Content-Type": "application/json"});

      try {
        final resData = jsonDecode(res.body);

        prefs.setString("token", resData["token"]!);
        prefs.setString("username", username);
        return _loadToken();
      } catch (e) {
        return LoginData(token: "", error: res.body.replaceAll("\"", ""), username: '', page: '');
      }
    });
  }

  Future<void> resetpw(String username, String oldPassword, String newPassword) async {
    state = const AsyncLoading();
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    state = await AsyncValue.guard(() async {
      final token = prefs.getString('token');
      final config = Config();
      final uri = Uri(scheme: config.scheme, host: config.host, port: config.port, path: "api/activate");
      final res = await http.post(uri,
          body: jsonEncode({
            "username": username,
            "old_password": oldPassword,
            "new_password": newPassword,
          }),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          });

      try {
        final resData = jsonDecode(res.body);

        prefs.setString("token", resData["token"]!);
        prefs.setString("username", username);
        prefs.remove('page');
        return _loadToken();
      } catch (e) {
        return LoginData(token: "", error: res.body.replaceAll("\"", ""), username: '', page: 'resetpw');
      }
    });
  }

  Future<void> register(String username, String password, String emailID) async {
    state = const AsyncLoading();
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    state = await AsyncValue.guard(() async {
      final config = Config();
      final uri = Uri(scheme: config.scheme, host: config.host, port: config.port, path: "api/register");
      final res = await http.post(
        uri,
        body: jsonEncode({
          "username": username,
          "password": password,
          "email_id": emailID,
        }),
        headers: {"Content-Type": "application/json"},
      );
      try {
        final resData = jsonDecode(res.body);
        prefs.setString("token", resData["token"]!);
        prefs.setString('username', username);
        return _loadToken();
      } catch (e) {
        return LoginData(token: "", error: res.body.replaceAll("\"", ""), username: '', page: 'register');
      }
    });
  }

  setPage(String page) {
    state = AsyncData(LoginData(token: '', error: '', username: '', page: page));
  }

  LoginData getData() {
    return state.value ?? LoginData(token: "", error: "", username: "", page: "");
  }
}
