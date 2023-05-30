import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zotit_flutter/src/screens/home/providers/note.dart';
import 'package:http/http.dart' as http;

part 'home_provider.g.dart';

// @riverpod
// Future<List<Note>> getNote(GetNoteRef ref) async {
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
  FutureOr<List<Note>> build() async {
    return _loadNotes();
  }

  Future<List<Note>> _loadNotes() async {
    final Future<SharedPreferences> fPrefs = SharedPreferences.getInstance();
    final prefs = await fPrefs;
    final token = prefs.getString('token');
    final uri = Uri.https('zotit.twobits.in', '/notes');
    final res = await http.get(uri, headers: {"Authorization": "Bearer $token"});
    final notes = jsonDecode(res.body) as List<dynamic>;
    return notes
        .map((item) => Note(
              id: item['id'],
              text: item['text'],
            ))
        .toList();
  }
}
