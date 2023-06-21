// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NoteListRepo _$NoteListRepoFromJson(Map<String, dynamic> json) {
  return _NoteListRepo.fromJson(json);
}

/// @nodoc
mixin _$NoteListRepo {
  List<Note> get notes => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NoteListRepoCopyWith<NoteListRepo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteListRepoCopyWith<$Res> {
  factory $NoteListRepoCopyWith(
          NoteListRepo value, $Res Function(NoteListRepo) then) =
      _$NoteListRepoCopyWithImpl<$Res, NoteListRepo>;
  @useResult
  $Res call({List<Note> notes, int page});
}

/// @nodoc
class _$NoteListRepoCopyWithImpl<$Res, $Val extends NoteListRepo>
    implements $NoteListRepoCopyWith<$Res> {
  _$NoteListRepoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notes = null,
    Object? page = null,
  }) {
    return _then(_value.copyWith(
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<Note>,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NoteListRepoCopyWith<$Res>
    implements $NoteListRepoCopyWith<$Res> {
  factory _$$_NoteListRepoCopyWith(
          _$_NoteListRepo value, $Res Function(_$_NoteListRepo) then) =
      __$$_NoteListRepoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Note> notes, int page});
}

/// @nodoc
class __$$_NoteListRepoCopyWithImpl<$Res>
    extends _$NoteListRepoCopyWithImpl<$Res, _$_NoteListRepo>
    implements _$$_NoteListRepoCopyWith<$Res> {
  __$$_NoteListRepoCopyWithImpl(
      _$_NoteListRepo _value, $Res Function(_$_NoteListRepo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notes = null,
    Object? page = null,
  }) {
    return _then(_$_NoteListRepo(
      notes: null == notes
          ? _value._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<Note>,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_NoteListRepo with DiagnosticableTreeMixin implements _NoteListRepo {
  _$_NoteListRepo({required final List<Note> notes, required this.page})
      : _notes = notes;

  factory _$_NoteListRepo.fromJson(Map<String, dynamic> json) =>
      _$$_NoteListRepoFromJson(json);

  final List<Note> _notes;
  @override
  List<Note> get notes {
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notes);
  }

  @override
  final int page;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NoteListRepo(notes: $notes, page: $page)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NoteListRepo'))
      ..add(DiagnosticsProperty('notes', notes))
      ..add(DiagnosticsProperty('page', page));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NoteListRepo &&
            const DeepCollectionEquality().equals(other._notes, _notes) &&
            (identical(other.page, page) || other.page == page));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_notes), page);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NoteListRepoCopyWith<_$_NoteListRepo> get copyWith =>
      __$$_NoteListRepoCopyWithImpl<_$_NoteListRepo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_NoteListRepoToJson(
      this,
    );
  }
}

abstract class _NoteListRepo implements NoteListRepo {
  factory _NoteListRepo(
      {required final List<Note> notes,
      required final int page}) = _$_NoteListRepo;

  factory _NoteListRepo.fromJson(Map<String, dynamic> json) =
      _$_NoteListRepo.fromJson;

  @override
  List<Note> get notes;
  @override
  int get page;
  @override
  @JsonKey(ignore: true)
  _$$_NoteListRepoCopyWith<_$_NoteListRepo> get copyWith =>
      throw _privateConstructorUsedError;
}
