import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zotit/config.dart';
import 'package:http/http.dart' as http;

final config = Config();
Future<Response> httpGet(
    String path, Map<String, dynamic> queryParameters) async {
  final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
  final prefs = await fPrefs;
  var token = prefs.getString('token');
  final uri = Uri(
      scheme: config.scheme,
      host: config.host,
      port: config.port,
      path: path,
      queryParameters: queryParameters);
  final res = await http.get(uri, headers: {
    "Authorization": "Bearer $token",
    "Content-Type": "application/json"
  });
  if (res.body == "Invalid or expired JWT") {
    await refreshToken(prefs.getString('refresh_token'));
    token = prefs.getString('token');
    final ress = await http.get(uri, headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    });
    return ress;
  } else {
    return res;
  }
}

Future<Response> httpPost(String path, Map<String, dynamic> queryParameters,
    Map<String, dynamic> body) async {
  final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
  final prefs = await fPrefs;
  var token = prefs.getString('token');
  final uri = Uri(
      scheme: config.scheme,
      host: config.host,
      port: config.port,
      path: path,
      queryParameters: queryParameters);
  final res = await http.post(
    uri,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    },
    body: jsonEncode(body),
  );
  if (res.body == "Invalid or expired JWT") {
    await refreshToken(prefs.getString('refresh_token'));
    token = prefs.getString('token');
    final ress = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    );
    return ress;
  } else {
    return res;
  }
}

Future<Response> httpPut(String path, Map<String, dynamic> queryParameters,
    Map<String, dynamic> body) async {
  final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
  final prefs = await fPrefs;
  var token = prefs.getString('token');
  final uri = Uri(
      scheme: config.scheme,
      host: config.host,
      port: config.port,
      path: path,
      queryParameters: queryParameters);
  final res = await http.put(
    uri,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    },
    body: jsonEncode(body),
  );
  if (res.body == "Invalid or expired JWT") {
    await refreshToken(prefs.getString('refresh_token'));
    token = prefs.getString('token');
    final ress = await http.put(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    );
    return ress;
  } else {
    return res;
  }
}

Future<Response> httpDelete(String path, Map<String, dynamic> queryParameters,
    Map<String, dynamic> body) async {
  final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
  final prefs = await fPrefs;
  var token = prefs.getString('token');
  final uri = Uri(
      scheme: config.scheme,
      host: config.host,
      port: config.port,
      path: path,
      queryParameters: queryParameters);
  final res = await http.delete(
    uri,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    },
    body: jsonEncode(body),
  );
  if (res.body == "Invalid or expired JWT") {
    await refreshToken(prefs.getString('refresh_token'));
    token = prefs.getString('token');
    final ress = await http.delete(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    );
    return ress;
  } else {
    return res;
  }
}

refreshToken(String? token) async {
  final uri = Uri(
      scheme: config.scheme,
      host: config.host,
      port: config.port,
      path: 'api/refresh');
  final res = await http.post(uri, headers: {
    "Authorization": "Bearer $token",
  });
  final resData = jsonDecode(res.body);
  final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
  final prefs = await fPrefs;
  prefs.setString("token", resData["token"]!);
  prefs.setString("refresh_token", resData["refresh_token"]!);
}
