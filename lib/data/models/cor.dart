import 'package:json_annotation/json_annotation.dart';

part 'cor.g.dart';

@JsonSerializable()
class Cor {
  final int idCor;
  final String codigoCor;
  final String designacaoCor;
  final int idEstado;
  
  // Permitir null do backend e converter
  @JsonKey(defaultValue: true)
  final bool? ativo;

  Cor({
    required this.idCor,
    required this.codigoCor,
    required this.designacaoCor,
    required this.idEstado,
    this.ativo,
  });

  // Propriedade computada - sempre retorna bool
  bool get isAtivo => ativo ?? (idEstado == 1);
  
  String get codigoDesignacao => '$codigoCor - $designacaoCor';

  factory Cor.fromJson(Map<String, dynamic> json) => _$CorFromJson(json);
  Map<String, dynamic> toJson() => _$CorToJson(this);
}
