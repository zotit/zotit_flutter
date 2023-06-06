// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LoginData _$LoginDataFromJson(Map<String, dynamic> json) {
  return _LoginData.fromJson(json);
}

/// @nodoc
mixin _$LoginData {
  String get token => throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoginDataCopyWith<LoginData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginDataCopyWith<$Res> {
  factory $LoginDataCopyWith(LoginData value, $Res Function(LoginData) then) =
      _$LoginDataCopyWithImpl<$Res, LoginData>;
  @useResult
  $Res call({String token, String error, String username});
}

/// @nodoc
class _$LoginDataCopyWithImpl<$Res, $Val extends LoginData>
    implements $LoginDataCopyWith<$Res> {
  _$LoginDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? error = null,
    Object? username = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LoginDataCopyWith<$Res> implements $LoginDataCopyWith<$Res> {
  factory _$$_LoginDataCopyWith(
          _$_LoginData value, $Res Function(_$_LoginData) then) =
      __$$_LoginDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token, String error, String username});
}

/// @nodoc
class __$$_LoginDataCopyWithImpl<$Res>
    extends _$LoginDataCopyWithImpl<$Res, _$_LoginData>
    implements _$$_LoginDataCopyWith<$Res> {
  __$$_LoginDataCopyWithImpl(
      _$_LoginData _value, $Res Function(_$_LoginData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? error = null,
    Object? username = null,
  }) {
    return _then(_$_LoginData(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_LoginData with DiagnosticableTreeMixin implements _LoginData {
  _$_LoginData(
      {required this.token, required this.error, required this.username});

  factory _$_LoginData.fromJson(Map<String, dynamic> json) =>
      _$$_LoginDataFromJson(json);

  @override
  final String token;
  @override
  final String error;
  @override
  final String username;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoginData(token: $token, error: $error, username: $username)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LoginData'))
      ..add(DiagnosticsProperty('token', token))
      ..add(DiagnosticsProperty('error', error))
      ..add(DiagnosticsProperty('username', username));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LoginData &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.username, username) ||
                other.username == username));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, token, error, username);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LoginDataCopyWith<_$_LoginData> get copyWith =>
      __$$_LoginDataCopyWithImpl<_$_LoginData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LoginDataToJson(
      this,
    );
  }
}

abstract class _LoginData implements LoginData {
  factory _LoginData(
      {required final String token,
      required final String error,
      required final String username}) = _$_LoginData;

  factory _LoginData.fromJson(Map<String, dynamic> json) =
      _$_LoginData.fromJson;

  @override
  String get token;
  @override
  String get error;
  @override
  String get username;
  @override
  @JsonKey(ignore: true)
  _$$_LoginDataCopyWith<_$_LoginData> get copyWith =>
      throw _privateConstructorUsedError;
}
