// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteImpl _$$NoteImplFromJson(Map<String, dynamic> json) => _$NoteImpl(
      id: json['id'] as String,
      text: json['text'] as String,
      is_obscure: json['is_obscure'] as bool,
      tag: json['tag'] == null
          ? null
          : NoteTag.fromJson(json['tag'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$NoteImplToJson(_$NoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'is_obscure': instance.is_obscure,
      'tag': instance.tag,
    };
