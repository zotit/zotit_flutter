import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'apptheme_data_provider.g.dart';

class AppData {
  final bool? isDarkMode;
  final bool isListView;
  AppData({required this.isDarkMode, required this.isListView});
}

@riverpod
class AppThemeData extends _$AppThemeData {
  final Future<SharedPreferences> _fPrefs = SharedPreferences.getInstance();
  late SharedPreferences _prefs;

  @override
  Future<AppData> build() async {
    _prefs = await _fPrefs;
    final isDarkMode = await _loadMode();
    final isListView = await _loadListView();
    return AppData(isDarkMode: isDarkMode, isListView: isListView);
  }

  Future<bool?> _loadMode() async {
    if (!_prefs.containsKey('darkMode')) {
      return null;
    }
    return _prefs.getBool('darkMode');
  }

  Future<bool> _loadListView() async {
    final listView = _prefs.getBool('listView') ?? false;
    return listView;
  }

  setListView(bool listView) async {
    _prefs.setBool('listView', listView);
    state = const AsyncLoading();
    final isDarkMode = await _loadMode();
    state = AsyncData(AppData(isDarkMode: isDarkMode, isListView: listView));
  }

  setMode(bool? darkMode) async {
    state = const AsyncLoading();
    if (darkMode == null) {
      await _prefs.remove('darkMode');
    } else {
      await _prefs.setBool('darkMode', darkMode);
    }
    final isListView = await _loadListView();
    state = AsyncData(AppData(isDarkMode: darkMode, isListView: isListView));
  }
}
