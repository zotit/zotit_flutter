// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteListRepoImpl _$$NoteListRepoImplFromJson(Map<String, dynamic> json) =>
    _$NoteListRepoImpl(
      notes: (json['notes'] as List<dynamic>)
          .map((e) => Note.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num).toInt(),
    );

Map<String, dynamic> _$$NoteListRepoImplToJson(_$NoteListRepoImpl instance) =>
    <String, dynamic>{
      'notes': instance.notes,
      'page': instance.page,
    };
