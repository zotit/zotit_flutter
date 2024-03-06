import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zotit/config.dart';
import 'package:zotit/src/providers/login_provider/login_provider.dart';
import 'package:zotit/src/screens/home/providers/note.dart';
import 'package:http/http.dart' as http;
import 'package:zotit/src/screens/home/providers/note_list.dart';
import 'package:zotit/src/screens/tags/providers/note_tag.dart';
import 'package:zotit/src/utils/httpn.dart';

part 'home_provider.g.dart';

@riverpod
class NoteList extends _$NoteList {
  @override
  FutureOr<NoteListRepo> build() async {
    return _loadNotes();
  }

  Future<NoteListRepo> _loadNotes() async {
    final res = await httpGet("api/notes", {});
    final notes = jsonDecode(res.body) as List<dynamic>;
    return NoteListRepo(
        notes: notes.map((item) {
          var runes = (item['text'] as String).runes.toList();
          return Note(
            id: item['id'],
            text: utf8.decode(runes),
            is_obscure: item['is_obscure'],
            tag: item['tag'] != null
                ? NoteTag(
                    id: item['tag']['id'],
                    name: item['tag']['name'],
                    color: item['tag']['color'])
                : NoteTag(
                    id: "",
                    name: "Assign Tag",
                    color: const Color(0xff9e9e9e).value),
          );
        }).toList(),
        page: 1);
  }

  getNotesByPage(text, tagId) async {
    final newPage = state.value!.page + 1;

    final res = await httpGet("api/notes", {
      'page': newPage.toString(),
      'text': text,
      'tag_id': tagId,
    });
    if (res.body == "Invalid or expired JWT") {
      final loginData = ref.read(loginTokenProvider.notifier);
      loginData.logout();
      return [];
    }
    try {
      final notes = jsonDecode(res.body) as List<dynamic>;
      var noteList = notes
          .map((item) => Note(
                id: item['id'],
                text: item['text'],
                is_obscure: item['is_obscure'],
                tag: item['tag'] != null
                    ? NoteTag(
                        id: item['tag']['id'],
                        name: item['tag']['name'],
                        color: item['tag']['color'])
                    : NoteTag(
                        id: "",
                        name: "Assign Tag",
                        color: const Color(0xff9e9e9e).value),
              ))
          .toList();
      var stateValue = state.value != null ? state.value?.notes : [];
      state = AsyncValue.data(
          NoteListRepo(notes: [...?stateValue, ...noteList], page: newPage));
    } catch (e) {
      state = AsyncError("error ${res.body}", StackTrace.current);
    }
  }

  searchNotes(text, tagId) async {
    final res = await httpGet("api/notes", {
      'text': text,
      'tag_id': tagId,
    });
    if (res.body == "Invalid or expired JWT") {
      final loginData = ref.read(loginTokenProvider.notifier);
      loginData.logout();
      return [];
    }
    try {
      final notes = jsonDecode(res.body) as List<dynamic>;
      var noteList = notes
          .map((item) => Note(
                id: item['id'],
                text: item['text'],
                is_obscure: item['is_obscure'],
                tag: item['tag'] != null
                    ? NoteTag(
                        id: item['tag']['id'],
                        name: item['tag']['name'],
                        color: item['tag']['color'])
                    : NoteTag(
                        id: "",
                        name: "Assign Tag",
                        color: const Color(0xff9e9e9e).value),
              ))
          .toList();
      state = AsyncValue.data(
          NoteListRepo(notes: [...noteList], page: state.value!.page));
    } catch (e) {
      state = AsyncError("error ${res.body}", StackTrace.current);
    }
  }

  updateLocalNote(
      String? text, bool? isObscure, index, NoteTag? tag, bool isRemoveTag) {
    if (state.asData != null) {
      var stateValue = state.value?.notes.toList();
      stateValue?[index] = Note(
        id: stateValue[index].id,
        text: text ?? stateValue[index].text,
        is_obscure: isObscure ?? stateValue[index].is_obscure,
        tag: tag ??
            (isRemoveTag
                ? NoteTag(id: "", name: "Assign Tag", color: 0xff9e9e9e)
                : stateValue[index].tag),
      );
      state = AsyncValue.data(
          NoteListRepo(notes: [...?stateValue], page: state.value!.page));
    }
  }

  prependLocalNote(String id, String text, bool isObscure) {
    if (state.asData != null) {
      var stateValue = state.value?.notes.toList();
      var newNote = Note(
          id: id,
          text: text,
          is_obscure: isObscure,
          tag: NoteTag(
              id: "",
              name: "Assign Tag",
              color: const Color(0xff9e9e9e).value));

      state = AsyncValue.data(NoteListRepo(
          notes: [newNote, ...?stateValue], page: state.value!.page));
    }
  }

  deleteLocalNote(index) {
    if (state.asData != null) {
      var stateValue = state.value?.notes.toList();
      stateValue?.removeAt(index);
      state = AsyncValue.data(
          NoteListRepo(notes: [...?stateValue], page: state.value!.page));
    }
  }
}
