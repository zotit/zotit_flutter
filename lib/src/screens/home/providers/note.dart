import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:zotit/src/screens/tags/providers/note_tag.dart';

part 'note.freezed.dart';
// optional: Since our Person class is serializable, we must add this line.
// But if Person was not serializable, we could skip it.
part 'note.g.dart';

@freezed
class Note with _$Note {
  factory Note({
    required String id,
    required String text,
    required bool is_obscure,
    required NoteTag? tag,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}
