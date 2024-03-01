import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'note_text_provider.g.dart';

@riverpod
class NoteText extends _$NoteText {
  final Future<SharedPreferences> _fPrefs = SharedPreferences.getInstance();

  @override
  FutureOr<String> build() async {
    return _loadText();
  }

  FutureOr<String> _loadText() async {
    final prefs = await _fPrefs;
    final username = prefs.getString('text') ?? "";
    return username;
  }

  setText(String text) async {
    state = const AsyncLoading();
    final prefs = await _fPrefs;
    prefs.setString('text', text);
    state = AsyncData(text);
  }
}
