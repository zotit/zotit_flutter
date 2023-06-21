// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NoteListRepo _$$_NoteListRepoFromJson(Map<String, dynamic> json) =>
    _$_NoteListRepo(
      notes: (json['notes'] as List<dynamic>)
          .map((e) => Note.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int,
    );

Map<String, dynamic> _$$_NoteListRepoToJson(_$_NoteListRepo instance) =>
    <String, dynamic>{
      'notes': instance.notes,
      'page': instance.page,
    };
