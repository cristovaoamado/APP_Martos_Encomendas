import 'package:json_annotation/json_annotation.dart';

part 'cliente.g.dart';

@JsonSerializable()
class Cliente {
  final int idCliente;
  final String? codigoCliente;
  final String? nomeCliente;
  final String? nif;
  final String? email;
  final String? telefone;
  final String? rua;
  final String? localidade;
  final String? codigoPostal;
  final bool? ativo;
  final String? usernameVendedor;
  final String? nomeVendedor;
  final String? emailVendedor;

  Cliente({
    required this.idCliente,
    this.codigoCliente,
    this.nomeCliente,
    this.nif,
    this.email,
    this.telefone,
    this.rua,
    this.localidade,
    this.codigoPostal,
    this.ativo,
    this.usernameVendedor,
    this.nomeVendedor,
    this.emailVendedor,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) =>
      _$ClienteFromJson(json);
  Map<String, dynamic> toJson() => _$ClienteToJson(this);
  
  String get enderecoCompleto {
    final parts = <String>[];
    if (rua != null && rua!.isNotEmpty) parts.add(rua!);
    if (localidade != null && localidade!.isNotEmpty) parts.add(localidade!);
    if (codigoPostal != null && codigoPostal!.isNotEmpty) parts.add(codigoPostal!);
    return parts.join(', ');
  }
}
