// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cor _$CorFromJson(Map<String, dynamic> json) => Cor(
  idCor: (json['idCor'] as num).toInt(),
  codigoCor: json['codigoCor'] as String,
  designacaoCor: json['designacaoCor'] as String,
  idEstado: (json['idEstado'] as num).toInt(),
  ativo: json['ativo'] as bool? ?? true,
);

Map<String, dynamic> _$CorToJson(Cor instance) => <String, dynamic>{
  'idCor': instance.idCor,
  'codigoCor': instance.codigoCor,
  'designacaoCor': instance.designacaoCor,
  'idEstado': instance.idEstado,
  'ativo': instance.ativo,
};
