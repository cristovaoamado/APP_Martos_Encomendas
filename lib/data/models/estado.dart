/// Modelo para Estado de Encomenda
class Estado {
  final int idEstado;
  final String designacaoEstado;

  const Estado({
    required this.idEstado,
    required this.designacaoEstado,
  });

  factory Estado.fromJson(Map<String, dynamic> json) {
    return Estado(
      idEstado: json['idEstado'] as int,
      designacaoEstado: json['designacaoEstado'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idEstado': idEstado,
      'designacaoEstado': designacaoEstado,
    };
  }

  @override
  String toString() => 'Estado(id: $idEstado, designacao: $designacaoEstado)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Estado && other.idEstado == idEstado;
  }

  @override
  int get hashCode => idEstado.hashCode;
}
