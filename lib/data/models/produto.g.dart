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
  precoProduto: (json['precoProduto'] as num?)?.toDouble(),
  ativo: json['ativo'] as bool,
);

Map<String, dynamic> _$ProdutoToJson(Produto instance) => <String, dynamic>{
  'idProduto': instance.idProduto,
  'codigoProduto': instance.codigoProduto,
  'designacaoProduto': instance.designacaoProduto,
  'idEstado': instance.idEstado,
  'precoProduto': instance.precoProduto,
  'ativo': instance.ativo,
};
