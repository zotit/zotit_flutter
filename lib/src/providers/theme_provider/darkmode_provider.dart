import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'darkmode_provider.g.dart';

@riverpod
class DarkMode extends _$DarkMode {
  final Future<SharedPreferences> _fPrefs = SharedPreferences.getInstance();
  late SharedPreferences _prefs;

  @override
  Future<bool> build() async {
    _prefs = await _fPrefs;
    return _loadMode();
  }

  FutureOr<bool> _loadMode() async {
    final darkMode = _prefs.getBool('darkMode') ?? false;
    return darkMode;
  }

  setMode(bool darkMode) async {
    state = const AsyncLoading();
    _prefs.setBool('darkMode', darkMode);
    state = AsyncData(darkMode);
  }
}
