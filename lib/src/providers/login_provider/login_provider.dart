import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zotit/config.dart';
import 'package:zotit/src/screens/login/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:zotit/src/utils/httpn.dart';

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
    final page = prefs.getString('page') ?? "";
    final username = prefs.getString('username') ?? "";
    if (username != "") {
      return LoginData(error: "", username: username, page: page);
    }

    return LoginData(error: "", username: "", page: page);
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    await prefs.clear();
    state = AsyncData(LoginData(error: "", username: "", page: ""));
  }

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    state = await AsyncValue.guard(() async {
      final config = Config();
      final uri = Uri(
          scheme: config.scheme,
          host: config.host,
          port: config.port,
          path: "api/login");
      final res = await http.post(uri,
          body: jsonEncode({
            "username": username,
            "password": password,
          }),
          headers: {"Content-Type": "application/json"});

      try {
        final resData = jsonDecode(res.body);

        prefs.setString("token", resData["token"]!);
        prefs.setString("refresh_token", resData["refresh_token"]!);
        prefs.setString("username", username);

        if (!resData['is_active']) {
          prefs.setString("page", 'resetpw');
          prefs.setString("_p", password);
          return _loadToken();
        }
        prefs.remove("page");
        return _loadToken();
      } catch (e) {
        return LoginData(
            error: res.body.replaceAll("\"", ""), username: '', page: '');
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
      final uri = Uri(
          scheme: config.scheme,
          host: config.host,
          port: config.port,
          path: "api/forgotpw");
      final res = await http.post(uri,
          body: jsonEncode({
            "username": username,
          }),
          headers: {"Content-Type": "application/json"});

      try {
        await prefs.clear();
        return LoginData(
            error: res.body.replaceAll("\"", ""), username: "", page: "");
      } catch (e) {
        return LoginData(
          error: res.body.replaceAll("\"", ""),
          username: '',
          page: 'forgotpw',
        );
      }
    });
  }

  Future<void> resetpw(String newPassword) async {
    state = const AsyncLoading();
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    String username = prefs.getString("username") ?? "";
    state = await AsyncValue.guard(() async {
      final token = prefs.getString('token');
      final p = prefs.getString('_p');
      final config = Config();
      final uri = Uri(
          scheme: config.scheme,
          host: config.host,
          port: config.port,
          path: "api/activate");
      final res = await http.post(uri,
          body: jsonEncode({
            "username": username,
            "old_password": p,
            "new_password": newPassword,
          }),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          });

      try {
        await prefs.clear();
        return LoginData(
            error: res.body.replaceAll("\"", ""), username: "", page: "");
      } catch (e) {
        return LoginData(
            error: res.body.replaceAll("\"", ""), username: '', page: '');
      }
    });
  }

  Future<void> register(
      String username, String password, String emailID) async {
    state = const AsyncLoading();
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    state = await AsyncValue.guard(() async {
      final config = Config();
      final uri = Uri(
          scheme: config.scheme,
          host: config.host,
          port: config.port,
          path: "api/register");
      try {
        final res = await http.post(
          uri,
          body: jsonEncode({
            "username": username,
            "password": password,
            "email_id": emailID,
          }),
          headers: {"Content-Type": "application/json"},
        );
        await prefs.clear();
        return LoginData(
          error: res.body.replaceAll("\"", ""),
          username: '',
          page: '',
        );
      } catch (e) {
        return LoginData(
          error: "Failed to register. Please try agian",
          username: '',
          page: 'register',
        );
      }
    });
  }

  setPage(String page) {
    state = AsyncData(LoginData(error: '', username: '', page: page));
  }

  LoginData getData() {
    return state.value ?? LoginData(error: "", username: "", page: "");
  }

  Future<void> updateProfile(String username, String emailId) async {
    state = const AsyncLoading();
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    state = await AsyncValue.guard(() async {
      try {
        await httpPatch(
            "api/me", {}, {"username": username, "email_id": emailId});
        await prefs.setString("username", username);

        return _loadToken();
      } catch (e) {
        return LoginData(
          error: e.toString(),
          username: username,
          page: '',
        );
      }
    });
  }

  Future<void> deleteAccount(
      String password, String reason, String otherReason) async {
    state = const AsyncLoading();
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    state = await AsyncValue.guard(() async {
      final res = await httpDelete("api/me", {}, {
        "password": password,
        "reason": reason,
        "reason_other": otherReason,
      });

      if (res.statusCode == 200) {
        await prefs.clear();
        return LoginData(error: "", username: "", page: '');
      } else {
        return LoginData(
            error: res.body.replaceAll("\"", ""), username: "", page: '');
      }
    });
  }
}
