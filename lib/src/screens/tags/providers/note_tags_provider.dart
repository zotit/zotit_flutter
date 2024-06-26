import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zotit/config.dart';
import 'package:zotit/src/providers/login_provider/login_provider.dart';
import 'package:http/http.dart' as http;
import 'package:zotit/src/screens/tags/providers/note_tag.dart';
import 'package:zotit/src/screens/tags/providers/note_tag_list.dart';
import 'package:zotit/src/utils/httpn.dart';

part 'note_tags_provider.g.dart';

@riverpod
class NoteTagList extends _$NoteTagList {
  @override
  FutureOr<NoteTagListRepo> build() async {
    return _loadNoteTags();
  }

  Future<NoteTagListRepo> _loadNoteTags() async {
    final res = await httpGet("api/tags", {});
    try {
      final noteTags = jsonDecode(res.body) as List<dynamic>;
      return NoteTagListRepo(
          noteTags: noteTags.map((item) {
            var runes = (item['name'] as String).runes.toList();
            return NoteTag(
              id: item['id'],
              color: item['color'],
              name: utf8.decode(runes),
            );
          }).toList(),
          page: 1);
    } catch (e) {
      ref.watch(loginTokenProvider.notifier).logout();
      return Future.error(e);
    }
  }

  getNoteTagsByPage() async {
    final newPage = state.value!.page + 1;
    final res = await httpGet("api/tags", {'page': newPage.toString()});
    if (res.body == "Invalid or expired JWT") {
      final loginData = ref.read(loginTokenProvider.notifier);
      loginData.logout();
      return [];
    }
    try {
      final noteTags = jsonDecode(res.body) as List<dynamic>;
      var noteTagList = noteTags
          .map((item) => NoteTag(
                id: item['id'],
                name: item['name'],
                color: item['color'],
              ))
          .toList();
      var stateValue = state.value != null ? state.value?.noteTags : [];
      state = AsyncValue.data(NoteTagListRepo(
          noteTags: [...?stateValue, ...noteTagList], page: newPage));
    } catch (e) {
      state = AsyncError("error ${res.body}", StackTrace.current);
    }
  }

  updateLocalNoteTag(String name, int color, index) {
    if (state.asData != null) {
      var stateValue = state.value?.noteTags.toList();
      stateValue?[index] =
          NoteTag(id: stateValue[index].id, name: name, color: color);
      state = AsyncValue.data(
          NoteTagListRepo(noteTags: [...?stateValue], page: state.value!.page));
    }
  }
}
