import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'note_text_provider.g.dart';

@riverpod
class NoteText extends _$NoteText {
  final Future<SharedPreferences> _fPrefs = SharedPreferences.getInstance();
  late SharedPreferences _prefs;

  @override
  FutureOr<String> build() async {
    _prefs = await _fPrefs;
    return _loadText();
  }

  FutureOr<String> _loadText() async {
    final username = _prefs.getString('text') ?? "";
    return username;
  }

  setText(String text, bool updateState) async {
    _prefs.setString('text', text);
    if (updateState) {
      state = const AsyncLoading();
      state = AsyncData(text);
    }
  }
}
