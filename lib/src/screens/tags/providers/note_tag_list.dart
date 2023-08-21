import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:zotit/src/screens/home/providers/note.dart';
import 'package:zotit/src/screens/tags/providers/note_tag.dart';

part 'note_tag_list.freezed.dart';
// optional: Since our Person class is serializable, we must add this line.
// But if Person was not serializable, we could skip it.
part 'note_tag_list.g.dart';

@freezed
class NoteTagListRepo with _$NoteTagListRepo {
  factory NoteTagListRepo({
    required List<NoteTag> noteTags,
    required int page,
  }) = _NoteTagListRepo;

  factory NoteTagListRepo.fromJson(Map<String, dynamic> json) => _$NoteTagListRepoFromJson(json);
}
