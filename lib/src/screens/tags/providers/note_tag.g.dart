// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteTagImpl _$$NoteTagImplFromJson(Map<String, dynamic> json) =>
    _$NoteTagImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      color: (json['color'] as num).toInt(),
    );

Map<String, dynamic> _$$NoteTagImplToJson(_$NoteTagImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
    };
