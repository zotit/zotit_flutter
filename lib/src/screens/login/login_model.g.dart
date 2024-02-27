// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginDataImpl _$$LoginDataImplFromJson(Map<String, dynamic> json) =>
    _$LoginDataImpl(
      error: json['error'] as String,
      username: json['username'] as String,
      emailId: json['emailId'] as String,
      page: json['page'] as String,
    );

Map<String, dynamic> _$$LoginDataImplToJson(_$LoginDataImpl instance) =>
    <String, dynamic>{
      'error': instance.error,
      'username': instance.username,
      'emailId': instance.emailId,
      'page': instance.page,
    };
