import 'package:json_annotation/json_annotation.dart';

part 'produto.g.dart';

@JsonSerializable()
class Produto {
  final int idProduto;
  final String codigoProduto;
  final String designacaoProduto;
  final int idEstado;
  
  @JsonKey(name: 'precoProduto')
  final double? precoProduto;
  
  final bool ativo;

  Produto({
    required this.idProduto,
    required this.codigoProduto,
    required this.designacaoProduto,
    required this.idEstado,
    this.precoProduto,
    required this.ativo,
  });

  // Propriedade computada para facilitar o uso
  String get codigoDesignacao => '$codigoProduto - $designacaoProduto';

  factory Produto.fromJson(Map<String, dynamic> json) => _$ProdutoFromJson(json);
  Map<String, dynamic> toJson() => _$ProdutoToJson(this);
}
