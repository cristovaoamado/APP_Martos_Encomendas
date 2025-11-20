import 'package:json_annotation/json_annotation.dart';

part 'cliente.g.dart';

@JsonSerializable()
class Cliente {
  // Identificação
  final int idCliente;
  final String? codigoCliente;
  final String? nomeCliente;
  final String? nif;
  
  // Contacto principal
  final String? emailCliente;
  final String? telefoneCliente;
  
  // ENDEREÇO - Nomes EXATOS que vêm da API!
  final String? ruaCliente;
  final String? localidadeCliente;
  final String? cpostalCliente;
  
  // CONTACTO ADICIONAL - Nomes EXATOS que vêm da API!
  final String? nomeContactoCliente;
  final String? emailContactoCliente;
  final String? telefoneContactoCliente;
  
  // Vendedor
  final String? usernameVendedor;
  final String? nomeVendedor;
  final String? emailVendedor;
  
  // Estado
  final int? idEstado;
  final bool? ativo;

  Cliente({
    required this.idCliente,
    this.codigoCliente,
    this.nomeCliente,
    this.nif,
    this.emailCliente,
    this.telefoneCliente,
    this.ruaCliente,
    this.localidadeCliente,
    this.cpostalCliente,
    this.nomeContactoCliente,
    this.emailContactoCliente,
    this.telefoneContactoCliente,
    this.usernameVendedor,
    this.nomeVendedor,
    this.emailVendedor,
    this.idEstado,
    this.ativo,
  });

  // Getters para compatibilidade com código antigo (se necessário)
  String? get email => emailCliente;
  String? get telefone => telefoneCliente;
  String? get rua => ruaCliente;
  String? get localidade => localidadeCliente;
  String? get codigoPostal => cpostalCliente;

  factory Cliente.fromJson(Map<String, dynamic> json) =>
      _$ClienteFromJson(json);
  
  Map<String, dynamic> toJson() => _$ClienteToJson(this);
  
  String get enderecoCompleto {
    final parts = <String>[];
    if (ruaCliente != null && ruaCliente!.isNotEmpty) parts.add(ruaCliente!);
    if (localidadeCliente != null && localidadeCliente!.isNotEmpty) parts.add(localidadeCliente!);
    if (cpostalCliente != null && cpostalCliente!.isNotEmpty) parts.add(cpostalCliente!);
    return parts.join(', ');
  }
}
