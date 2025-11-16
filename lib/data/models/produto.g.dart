// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Produto _$ProdutoFromJson(Map<String, dynamic> json) => Produto(
  idProduto: (json['idProduto'] as num).toInt(),
  codigoProduto: json['codigoProduto'] as String,
  designacaoProduto: json['designacaoProduto'] as String,
  idEstado: (json['idEstado'] as num).toInt(),
  pvp1: (json['pvp1'] as num?)?.toDouble(),
  pvp2: (json['pvp2'] as num?)?.toDouble(),
  ativo: json['ativo'] as bool,
);

Map<String, dynamic> _$ProdutoToJson(Produto instance) => <String, dynamic>{
  'idProduto': instance.idProduto,
  'codigoProduto': instance.codigoProduto,
  'designacaoProduto': instance.designacaoProduto,
  'idEstado': instance.idEstado,
  'pvp1': instance.pvp1,
  'pvp2': instance.pvp2,
  'ativo': instance.ativo,
};
