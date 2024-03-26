import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zotit/src/utils/httpn.dart';
part 'profile.g.dart';

@riverpod
class Profile extends _$Profile {
  @override
  FutureOr<String> build() async {
    return _loadProfile();
  }

  Future<String> _loadProfile() async {
    final res = await httpGet("api/me", {});
    try {
      final resData = jsonDecode(res.body);
      return resData['email_id'];
    } catch (e) {
      return "";
    }
  }
}
