import 'package:json_annotation/json_annotation.dart';

part 'tamanho.g.dart';

@JsonSerializable()
class Tamanho {
  final int idTamanho;
  final String codigoTamanho;
  final String? designacaoTamanho;
  final int idEstado;
  final bool ativo;

  Tamanho({
    required this.idTamanho,
    required this.codigoTamanho,
    this.designacaoTamanho,
    required this.idEstado,
    required this.ativo,
  });

  // Propriedade computada
  String get codigoDesignacao {
    if (designacaoTamanho != null && designacaoTamanho!.isNotEmpty) {
      return '$codigoTamanho - $designacaoTamanho';
    }
    return codigoTamanho;
  }

  factory Tamanho.fromJson(Map<String, dynamic> json) => _$TamanhoFromJson(json);
  Map<String, dynamic> toJson() => _$TamanhoToJson(this);
}
