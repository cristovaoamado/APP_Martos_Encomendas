// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  oldUserId: (json['oldUserId'] as num?)?.toInt(),
  email: json['email'] as String,
  nome: json['nome'] as String,
  userActivo: json['userActivo'] as bool,
  maquinaConfecaoId: (json['maquinaConfecaoId'] as num?)?.toInt(),
  token: json['token'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'oldUserId': instance.oldUserId,
  'email': instance.email,
  'nome': instance.nome,
  'userActivo': instance.userActivo,
  'maquinaConfecaoId': instance.maquinaConfecaoId,
  'token': instance.token,
};
