// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_tag_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NoteTagListRepo _$$_NoteTagListRepoFromJson(Map<String, dynamic> json) =>
    _$_NoteTagListRepo(
      noteTags: (json['noteTags'] as List<dynamic>)
          .map((e) => NoteTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int,
    );

Map<String, dynamic> _$$_NoteTagListRepoToJson(_$_NoteTagListRepo instance) =>
    <String, dynamic>{
      'noteTags': instance.noteTags,
      'page': instance.page,
    };
