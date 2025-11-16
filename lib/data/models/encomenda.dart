import 'package:json_annotation/json_annotation.dart';

part 'encomenda.g.dart';

@JsonSerializable()
class Encomenda {
  final int idEncomenda;
  final int idCliente;
  final String? nomeCliente;
  final String? codigoCliente;
  final String? codigoBarras;
  final String? nomeVendedor;
  final String? emailVendedor;
  final double? valorTotal;
  final int idEstado;
  final String? designacaoEstado;
  final DateTime? dataInsertEncomenda;
  final DateTime? dataEntregaPrevista;
  final String? referenciaCliente;
  final String? observacoes;

  Encomenda({
    required this.idEncomenda,
    required this.idCliente,
    this.nomeCliente,
    this.codigoCliente,
    this.codigoBarras,
    this.nomeVendedor,
    this.emailVendedor,
    this.valorTotal,
    required this.idEstado,
    this.designacaoEstado,
    this.dataInsertEncomenda,
    this.dataEntregaPrevista,
    this.referenciaCliente,
    this.observacoes,
  });

  factory Encomenda.fromJson(Map<String, dynamic> json) =>
      _$EncomendaFromJson(json);
  Map<String, dynamic> toJson() => _$EncomendaToJson(this);
}

@JsonSerializable()
class EncomendaDetail {
  final int idEncomenda;
  final int idCliente;
  final String? nomeCliente;
  final String? codigoCliente;
  final String? nifCliente;
  final String? emailCliente;
  final String? telefoneCliente;
  final String? codigoBarras;
  final String? usernameVendedor;
  final String? nomeVendedor;
  final String? emailVendedor;
  final double? valorTotal;
  final int idEstado;
  final String? designacaoEstado;
  final DateTime? dataInsertEncomenda;
  final DateTime? dataEntregaPrevista;
  final String? enderecoEntrega1;
  final String? enderecoEntrega2;
  final String? enderecoEntrega3;
  final String? cpostalEntrega;
  final String? nomeContacto;
  final String? telefoneContacto;
  final String? referenciaCliente;
  final String? observacoes;
  final List<EncomendaDetalhe>? detalhes;

  EncomendaDetail({
    required this.idEncomenda,
    required this.idCliente,
    this.nomeCliente,
    this.codigoCliente,
    this.nifCliente,
    this.emailCliente,
    this.telefoneCliente,
    this.codigoBarras,
    this.usernameVendedor,
    this.nomeVendedor,
    this.emailVendedor,
    this.valorTotal,
    required this.idEstado,
    this.designacaoEstado,
    this.dataInsertEncomenda,
    this.dataEntregaPrevista,
    this.enderecoEntrega1,
    this.enderecoEntrega2,
    this.enderecoEntrega3,
    this.cpostalEntrega,
    this.nomeContacto,
    this.telefoneContacto,
    this.referenciaCliente,
    this.observacoes,
    this.detalhes,
  });

  factory EncomendaDetail.fromJson(Map<String, dynamic> json) =>
      _$EncomendaDetailFromJson(json);
  Map<String, dynamic> toJson() => _$EncomendaDetailToJson(this);
}

@JsonSerializable()
class EncomendaDetalhe {
  final int? idEncomendaDetalhe;
  final int? idEncomenda;
  final int idProduto;
  final String? codigoProduto;
  final String? designacaoProduto;
  final int idCor;
  final String? codigoCor;
  final String? designacaoCor;
  final int idTamanho;
  final String? codigoTamanho;
  final String? designacaoTamanho;
  final int quantidade;
  final double preco;
  final double? total;

  EncomendaDetalhe({
    this.idEncomendaDetalhe,
    this.idEncomenda,
    required this.idProduto,
    this.codigoProduto,
    this.designacaoProduto,
    required this.idCor,
    this.codigoCor,
    this.designacaoCor,
    required this.idTamanho,
    this.codigoTamanho,
    this.designacaoTamanho,
    required this.quantidade,
    required this.preco,
    this.total,
  });

  factory EncomendaDetalhe.fromJson(Map<String, dynamic> json) =>
      _$EncomendaDetalheFromJson(json);
  Map<String, dynamic> toJson() => _$EncomendaDetalheToJson(this);
  
  EncomendaDetalhe copyWith({
    int? idEncomendaDetalhe,
    int? idEncomenda,
    int? idProduto,
    String? codigoProduto,
    String? designacaoProduto,
    int? idCor,
    String? codigoCor,
    String? designacaoCor,
    int? idTamanho,
    String? codigoTamanho,
    String? designacaoTamanho,
    int? quantidade,
    double? preco,
    double? total,
  }) {
    return EncomendaDetalhe(
      idEncomendaDetalhe: idEncomendaDetalhe ?? this.idEncomendaDetalhe,
      idEncomenda: idEncomenda ?? this.idEncomenda,
      idProduto: idProduto ?? this.idProduto,
      codigoProduto: codigoProduto ?? this.codigoProduto,
      designacaoProduto: designacaoProduto ?? this.designacaoProduto,
      idCor: idCor ?? this.idCor,
      codigoCor: codigoCor ?? this.codigoCor,
      designacaoCor: designacaoCor ?? this.designacaoCor,
      idTamanho: idTamanho ?? this.idTamanho,
      codigoTamanho: codigoTamanho ?? this.codigoTamanho,
      designacaoTamanho: designacaoTamanho ?? this.designacaoTamanho,
      quantidade: quantidade ?? this.quantidade,
      preco: preco ?? this.preco,
      total: total ?? this.total,
    );
  }
}

@JsonSerializable()
class CreateEncomendaDto {
  final int idCliente;
  final DateTime dataEntregaPrevista;
  final String? enderecoEntrega1;
  final String? enderecoEntrega2;
  final String? enderecoEntrega3;
  final String? cpostalEntrega;
  final String? nomeContacto;
  final String? telefoneContacto;
  final String? referenciaCliente;
  final String? observacoes;
  final List<CreateEncomendaDetalheDto> detalhes;

  CreateEncomendaDto({
    required this.idCliente,
    required this.dataEntregaPrevista,
    this.enderecoEntrega1,
    this.enderecoEntrega2,
    this.enderecoEntrega3,
    this.cpostalEntrega,
    this.nomeContacto,
    this.telefoneContacto,
    this.referenciaCliente,
    this.observacoes,
    required this.detalhes,
  });

  factory CreateEncomendaDto.fromJson(Map<String, dynamic> json) =>
      _$CreateEncomendaDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateEncomendaDtoToJson(this);
}

@JsonSerializable()
class CreateEncomendaDetalheDto {
  final int idProduto;
  final int idCor;
  final int idTamanho;
  final int quantidade;
  final double preco;

  CreateEncomendaDetalheDto({
    required this.idProduto,
    required this.idCor,
    required this.idTamanho,
    required this.quantidade,
    required this.preco,
  });

  factory CreateEncomendaDetalheDto.fromJson(Map<String, dynamic> json) =>
      _$CreateEncomendaDetalheDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateEncomendaDetalheDtoToJson(this);
}
