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

  Future<String> _getProfile() async {
    final res = await httpGet("api/me", {});
    try {
      final resData = jsonDecode(res.body);
      return resData['email_id'];
    } catch (e) {
      return "";
    }
  }

  Future<LoginData> _loadToken() async {
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    final username = prefs.getString('username') ?? "";
    final page = prefs.getString('page') ?? "";
    final emailId = await _getProfile();
    if (emailId != "") {
      return LoginData(
          error: "", username: username, page: page, emailId: emailId);
    }

    return LoginData(error: "", username: username, page: page, emailId: "");
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    await prefs.clear();
    state =
        AsyncData(LoginData(error: "", username: "", emailId: "", page: ""));
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
          return _loadToken();
        }
        prefs.remove("page");
        return _loadToken();
      } catch (e) {
        return LoginData(
            error: res.body.replaceAll("\"", ""),
            username: '',
            page: '',
            emailId: '');
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
        final resData = jsonDecode(res.body);

        prefs.setString("token", resData["token"]!);
        await prefs.setString("username", username);
        return _loadToken();
      } catch (e) {
        return LoginData(
          error: res.body.replaceAll("\"", ""),
          username: '',
          page: 'forgotpw',
          emailId: state.value!.emailId,
        );
      }
    });
  }

  Future<void> resetpw(String oldPassword, String newPassword) async {
    state = const AsyncLoading();
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    String username = prefs.getString("username") ?? "";
    state = await AsyncValue.guard(() async {
      final token = prefs.getString('token');
      final config = Config();
      final uri = Uri(
          scheme: config.scheme,
          host: config.host,
          port: config.port,
          path: "api/activate");
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
        return LoginData(
            error: res.body.replaceAll("\"", ""),
            username: '',
            page: 'resetpw',
            emailId: state.value!.emailId);
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
        return LoginData(
            error: res.body.replaceAll("\"", ""),
            username: '',
            page: 'register',
            emailId: state.value!.emailId);
      }
    });
  }

  setPage(String page) {
    state = AsyncData(LoginData(
        error: '', username: '', page: page, emailId: state.value!.emailId));
  }

  LoginData getData() {
    return state.value ??
        LoginData(error: "", username: "", page: "", emailId: "");
  }

  Future<void> updateProfile(String username, String emailId) async {
    state = const AsyncLoading();
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    state = await AsyncValue.guard(() async {
      final token = prefs.getString('token');
      final config = Config();
      final uri = Uri(
          scheme: config.scheme,
          host: config.host,
          port: config.port,
          path: "api/me");
      final res = await http.patch(uri,
          body: jsonEncode({"username": username, "email_id": emailId}),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          });

      try {
        final _ = jsonDecode(res.body);
        prefs.setString("username", username);
        return _loadToken();
      } catch (e) {
        return LoginData(
            error: res.body.replaceAll("\"", ""),
            username: username,
            page: '',
            emailId: state.value!.emailId);
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
        return LoginData(error: "", username: "", page: '', emailId: "");
      } else {
        return LoginData(
            error: res.body.replaceAll("\"", ""),
            username: "",
            page: '',
            emailId: "");
      }
    });
  }
}
