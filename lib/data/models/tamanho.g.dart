// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tamanho.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tamanho _$TamanhoFromJson(Map<String, dynamic> json) => Tamanho(
  idTamanho: (json['idTamanho'] as num).toInt(),
  codigoTamanho: json['codigoTamanho'] as String,
  designacaoTamanho: json['designacaoTamanho'] as String?,
  idEstado: (json['idEstado'] as num).toInt(),
  ativo: json['ativo'] as bool,
);

Map<String, dynamic> _$TamanhoToJson(Tamanho instance) => <String, dynamic>{
  'idTamanho': instance.idTamanho,
  'codigoTamanho': instance.codigoTamanho,
  'designacaoTamanho': instance.designacaoTamanho,
  'idEstado': instance.idEstado,
  'ativo': instance.ativo,
};
