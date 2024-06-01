// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_tag_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteTagListRepoImpl _$$NoteTagListRepoImplFromJson(
        Map<String, dynamic> json) =>
    _$NoteTagListRepoImpl(
      noteTags: (json['noteTags'] as List<dynamic>)
          .map((e) => NoteTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num).toInt(),
    );

Map<String, dynamic> _$$NoteTagListRepoImplToJson(
        _$NoteTagListRepoImpl instance) =>
    <String, dynamic>{
      'noteTags': instance.noteTags,
      'page': instance.page,
    };
