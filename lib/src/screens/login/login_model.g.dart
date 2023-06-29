// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LoginData _$$_LoginDataFromJson(Map<String, dynamic> json) => _$_LoginData(
      token: json['token'] as String,
      error: json['error'] as String,
      username: json['username'] as String,
      page: json['page'] as String,
    );

Map<String, dynamic> _$$_LoginDataToJson(_$_LoginData instance) =>
    <String, dynamic>{
      'token': instance.token,
      'error': instance.error,
      'username': instance.username,
      'page': instance.page,
    };
