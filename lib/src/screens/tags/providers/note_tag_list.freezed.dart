// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_tag_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NoteTagListRepo _$NoteTagListRepoFromJson(Map<String, dynamic> json) {
  return _NoteTagListRepo.fromJson(json);
}

/// @nodoc
mixin _$NoteTagListRepo {
  List<NoteTag> get noteTags => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;

  /// Serializes this NoteTagListRepo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NoteTagListRepo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoteTagListRepoCopyWith<NoteTagListRepo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteTagListRepoCopyWith<$Res> {
  factory $NoteTagListRepoCopyWith(
          NoteTagListRepo value, $Res Function(NoteTagListRepo) then) =
      _$NoteTagListRepoCopyWithImpl<$Res, NoteTagListRepo>;
  @useResult
  $Res call({List<NoteTag> noteTags, int page});
}

/// @nodoc
class _$NoteTagListRepoCopyWithImpl<$Res, $Val extends NoteTagListRepo>
    implements $NoteTagListRepoCopyWith<$Res> {
  _$NoteTagListRepoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NoteTagListRepo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noteTags = null,
    Object? page = null,
  }) {
    return _then(_value.copyWith(
      noteTags: null == noteTags
          ? _value.noteTags
          : noteTags // ignore: cast_nullable_to_non_nullable
              as List<NoteTag>,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoteTagListRepoImplCopyWith<$Res>
    implements $NoteTagListRepoCopyWith<$Res> {
  factory _$$NoteTagListRepoImplCopyWith(_$NoteTagListRepoImpl value,
          $Res Function(_$NoteTagListRepoImpl) then) =
      __$$NoteTagListRepoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<NoteTag> noteTags, int page});
}

/// @nodoc
class __$$NoteTagListRepoImplCopyWithImpl<$Res>
    extends _$NoteTagListRepoCopyWithImpl<$Res, _$NoteTagListRepoImpl>
    implements _$$NoteTagListRepoImplCopyWith<$Res> {
  __$$NoteTagListRepoImplCopyWithImpl(
      _$NoteTagListRepoImpl _value, $Res Function(_$NoteTagListRepoImpl) _then)
      : super(_value, _then);

  /// Create a copy of NoteTagListRepo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noteTags = null,
    Object? page = null,
  }) {
    return _then(_$NoteTagListRepoImpl(
      noteTags: null == noteTags
          ? _value._noteTags
          : noteTags // ignore: cast_nullable_to_non_nullable
              as List<NoteTag>,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NoteTagListRepoImpl
    with DiagnosticableTreeMixin
    implements _NoteTagListRepo {
  _$NoteTagListRepoImpl(
      {required final List<NoteTag> noteTags, required this.page})
      : _noteTags = noteTags;

  factory _$NoteTagListRepoImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoteTagListRepoImplFromJson(json);

  final List<NoteTag> _noteTags;
  @override
  List<NoteTag> get noteTags {
    if (_noteTags is EqualUnmodifiableListView) return _noteTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_noteTags);
  }

  @override
  final int page;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NoteTagListRepo(noteTags: $noteTags, page: $page)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NoteTagListRepo'))
      ..add(DiagnosticsProperty('noteTags', noteTags))
      ..add(DiagnosticsProperty('page', page));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteTagListRepoImpl &&
            const DeepCollectionEquality().equals(other._noteTags, _noteTags) &&
            (identical(other.page, page) || other.page == page));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_noteTags), page);

  /// Create a copy of NoteTagListRepo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteTagListRepoImplCopyWith<_$NoteTagListRepoImpl> get copyWith =>
      __$$NoteTagListRepoImplCopyWithImpl<_$NoteTagListRepoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoteTagListRepoImplToJson(
      this,
    );
  }
}

abstract class _NoteTagListRepo implements NoteTagListRepo {
  factory _NoteTagListRepo(
      {required final List<NoteTag> noteTags,
      required final int page}) = _$NoteTagListRepoImpl;

  factory _NoteTagListRepo.fromJson(Map<String, dynamic> json) =
      _$NoteTagListRepoImpl.fromJson;

  @override
  List<NoteTag> get noteTags;
  @override
  int get page;

  /// Create a copy of NoteTagListRepo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoteTagListRepoImplCopyWith<_$NoteTagListRepoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
