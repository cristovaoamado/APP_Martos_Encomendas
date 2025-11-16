// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cliente _$ClienteFromJson(Map<String, dynamic> json) => Cliente(
  idCliente: (json['idCliente'] as num).toInt(),
  codigoCliente: json['codigoCliente'] as String?,
  nomeCliente: json['nomeCliente'] as String?,
  nif: json['nif'] as String?,
  email: json['email'] as String?,
  telefone: json['telefone'] as String?,
  rua: json['rua'] as String?,
  localidade: json['localidade'] as String?,
  codigoPostal: json['codigoPostal'] as String?,
  ativo: json['ativo'] as bool?,
  usernameVendedor: json['usernameVendedor'] as String?,
  nomeVendedor: json['nomeVendedor'] as String?,
  emailVendedor: json['emailVendedor'] as String?,
);

Map<String, dynamic> _$ClienteToJson(Cliente instance) => <String, dynamic>{
  'idCliente': instance.idCliente,
  'codigoCliente': instance.codigoCliente,
  'nomeCliente': instance.nomeCliente,
  'nif': instance.nif,
  'email': instance.email,
  'telefone': instance.telefone,
  'rua': instance.rua,
  'localidade': instance.localidade,
  'codigoPostal': instance.codigoPostal,
  'ativo': instance.ativo,
  'usernameVendedor': instance.usernameVendedor,
  'nomeVendedor': instance.nomeVendedor,
  'emailVendedor': instance.emailVendedor,
};
