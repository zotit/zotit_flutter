import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:zotit/src/screens/home/providers/note.dart';

part 'note_list.freezed.dart';
// optional: Since our Person class is serializable, we must add this line.
// But if Person was not serializable, we could skip it.
part 'note_list.g.dart';

@freezed
class NoteListRepo with _$NoteListRepo {
  factory NoteListRepo({
    required List<Note> notes,
    required int page,
  }) = _NoteListRepo;

  factory NoteListRepo.fromJson(Map<String, dynamic> json) => _$NoteListRepoFromJson(json);
}
