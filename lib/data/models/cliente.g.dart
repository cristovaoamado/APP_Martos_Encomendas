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
  emailCliente: json['emailCliente'] as String?,
  telefoneCliente: json['telefoneCliente'] as String?,
  ruaCliente: json['ruaCliente'] as String?,
  localidadeCliente: json['localidadeCliente'] as String?,
  cpostalCliente: json['cpostalCliente'] as String?,
  nomeContactoCliente: json['nomeContactoCliente'] as String?,
  emailContactoCliente: json['emailContactoCliente'] as String?,
  telefoneContactoCliente: json['telefoneContactoCliente'] as String?,
  usernameVendedor: json['usernameVendedor'] as String?,
  nomeVendedor: json['nomeVendedor'] as String?,
  emailVendedor: json['emailVendedor'] as String?,
  idEstado: (json['idEstado'] as num?)?.toInt(),
  ativo: json['ativo'] as bool?,
);

Map<String, dynamic> _$ClienteToJson(Cliente instance) => <String, dynamic>{
  'idCliente': instance.idCliente,
  'codigoCliente': instance.codigoCliente,
  'nomeCliente': instance.nomeCliente,
  'nif': instance.nif,
  'emailCliente': instance.emailCliente,
  'telefoneCliente': instance.telefoneCliente,
  'ruaCliente': instance.ruaCliente,
  'localidadeCliente': instance.localidadeCliente,
  'cpostalCliente': instance.cpostalCliente,
  'nomeContactoCliente': instance.nomeContactoCliente,
  'emailContactoCliente': instance.emailContactoCliente,
  'telefoneContactoCliente': instance.telefoneContactoCliente,
  'usernameVendedor': instance.usernameVendedor,
  'nomeVendedor': instance.nomeVendedor,
  'emailVendedor': instance.emailVendedor,
  'idEstado': instance.idEstado,
  'ativo': instance.ativo,
};
