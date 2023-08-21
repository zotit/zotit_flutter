// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_tag.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NoteTag _$NoteTagFromJson(Map<String, dynamic> json) {
  return _NoteTag.fromJson(json);
}

/// @nodoc
mixin _$NoteTag {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NoteTagCopyWith<NoteTag> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteTagCopyWith<$Res> {
  factory $NoteTagCopyWith(NoteTag value, $Res Function(NoteTag) then) =
      _$NoteTagCopyWithImpl<$Res, NoteTag>;
  @useResult
  $Res call({String id, String name, int color});
}

/// @nodoc
class _$NoteTagCopyWithImpl<$Res, $Val extends NoteTag>
    implements $NoteTagCopyWith<$Res> {
  _$NoteTagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NoteTagCopyWith<$Res> implements $NoteTagCopyWith<$Res> {
  factory _$$_NoteTagCopyWith(
          _$_NoteTag value, $Res Function(_$_NoteTag) then) =
      __$$_NoteTagCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, int color});
}

/// @nodoc
class __$$_NoteTagCopyWithImpl<$Res>
    extends _$NoteTagCopyWithImpl<$Res, _$_NoteTag>
    implements _$$_NoteTagCopyWith<$Res> {
  __$$_NoteTagCopyWithImpl(_$_NoteTag _value, $Res Function(_$_NoteTag) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = null,
  }) {
    return _then(_$_NoteTag(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_NoteTag with DiagnosticableTreeMixin implements _NoteTag {
  _$_NoteTag({required this.id, required this.name, required this.color});

  factory _$_NoteTag.fromJson(Map<String, dynamic> json) =>
      _$$_NoteTagFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int color;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NoteTag(id: $id, name: $name, color: $color)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NoteTag'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('color', color));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NoteTag &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, color);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NoteTagCopyWith<_$_NoteTag> get copyWith =>
      __$$_NoteTagCopyWithImpl<_$_NoteTag>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_NoteTagToJson(
      this,
    );
  }
}

abstract class _NoteTag implements NoteTag {
  factory _NoteTag(
      {required final String id,
      required final String name,
      required final int color}) = _$_NoteTag;

  factory _NoteTag.fromJson(Map<String, dynamic> json) = _$_NoteTag.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get color;
  @override
  @JsonKey(ignore: true)
  _$$_NoteTagCopyWith<_$_NoteTag> get copyWith =>
      throw _privateConstructorUsedError;
}
