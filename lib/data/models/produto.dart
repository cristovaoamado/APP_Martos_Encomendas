import 'package:json_annotation/json_annotation.dart';

part 'produto.g.dart';

@JsonSerializable()
class Produto {
  final int idProduto;
  final String codigoProduto;
  final String designacaoProduto;
  final int idEstado;
  final double? pvp1;
  final double? pvp2;
  final bool ativo;

  Produto({
    required this.idProduto,
    required this.codigoProduto,
    required this.designacaoProduto,
    required this.idEstado,
    this.pvp1,
    this.pvp2,
    required this.ativo,
  });

  // Propriedades computadas
  String get codigoDesignacao => '$codigoProduto - $designacaoProduto';
  double? get precoProduto => pvp1; // ou pvp2, dependendo da tua lógica

  factory Produto.fromJson(Map<String, dynamic> json) => _$ProdutoFromJson(json);
  Map<String, dynamic> toJson() => _$ProdutoToJson(this);
}
