import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'note_tag.freezed.dart';
// optional: Since our Person class is serializable, we must add this line.
// But if Person was not serializable, we could skip it.
part 'note_tag.g.dart';

@freezed
class NoteTag with _$NoteTag {
  factory NoteTag({
    required String id,
    required String name,
    required int color,
  }) = _NoteTag;

  factory NoteTag.fromJson(Map<String, dynamic> json) => _$NoteTagFromJson(json);
}
