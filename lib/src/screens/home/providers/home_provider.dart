import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zotit/config.dart';
import 'package:zotit/src/providers/login_provider/login_provider.dart';
import 'package:zotit/src/screens/home/providers/note.dart';
import 'package:http/http.dart' as http;
import 'package:zotit/src/screens/home/providers/note_list.dart';

part 'home_provider.g.dart';

// @riverpod
// Future<NoteListRepo> getNote(GetNoteRef ref) async {
//   final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
//   final prefs = await fPrefs;
//   final token = prefs.getString('token');
//   final uri = Uri.https('zotit.twobits.in', '/notes');
//   final res = await http.get(uri, headers: {"Authorization": "Bearer $token"});
//   print(res.body);
//   return [];
// }

@riverpod
class NoteList extends _$NoteList {
  @override
  FutureOr<NoteListRepo> build() async {
    return _loadNotes();
  }

  Future<NoteListRepo> _loadNotes() async {
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    final token = prefs.getString('token');
    final config = Config();
    final uri = Uri(scheme: config.scheme, host: config.host, port: config.port, path: "api/notes");
    final res = await http.get(uri, headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"});
    if (res.body == "Invalid or expired JWT") {
      final loginData = ref.read(loginTokenProvider.notifier);
      loginData.logout();
      return NoteListRepo(notes: [], page: 0);
    }
    final notes = jsonDecode(res.body) as List<dynamic>;
    return NoteListRepo(
        notes: notes.map((item) {
          var runes = (item['text'] as String).runes.toList();
          return Note(
            id: item['id'],
            text: utf8.decode(runes),
            is_obscure: item['is_obscure'],
          );
        }).toList(),
        page: 1);
  }

  getNotesByPage() async {
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    final token = prefs.getString('token');
    final newPage = state.value!.page + 1;
    final config = Config();
    final uri = Uri(
      scheme: config.scheme,
      host: config.host,
      port: config.port,
      path: "notes",
      queryParameters: {'page': newPage.toString()},
    );
    // final uri = Uri.https('zotit.twobits.in', '/notes', {'page': newPage.toString()});
    final res = await http.get(uri, headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"});
    if (res.body == "Invalid or expired JWT") {
      final loginData = ref.read(loginTokenProvider.notifier);
      loginData.logout();
      return [];
    }
    final notes = jsonDecode(res.body) as List<dynamic>;

    var noteList = notes
        .map((item) => Note(
              id: item['id'],
              text: item['text'],
              is_obscure: item['is_obscure'],
            ))
        .toList();
    var stateValue = state.value != null ? state.value?.notes : [];
    state = AsyncValue.data(NoteListRepo(notes: [...?stateValue, ...noteList], page: newPage));
  }

  updateLocalNote(String text, bool isObscure, index) {
    if (state.asData != null) {
      var stateValue = state.value?.notes.toList();
      stateValue?[index] = Note(id: stateValue[index].id, text: text, is_obscure: isObscure);
      state = AsyncValue.data(NoteListRepo(notes: [...?stateValue], page: state.value!.page));
    }
  }
}
