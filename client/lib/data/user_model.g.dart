// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      user_id: json['user_id'] as String?,
      password: json['password'] as String?,
      user_name: json['user_name'] as String?,
      user_img_url: json['user_img_url'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'user_id': instance.user_id,
      'password': instance.password,
      'user_name': instance.user_name,
      'user_img_url': instance.user_img_url,
    };
