// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encomenda.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Encomenda _$EncomendaFromJson(Map<String, dynamic> json) => Encomenda(
  idEncomenda: (json['idEncomenda'] as num).toInt(),
  idCliente: (json['idCliente'] as num).toInt(),
  nomeCliente: json['nomeCliente'] as String?,
  codigoCliente: json['codigoCliente'] as String?,
  codigoBarras: json['codigoBarras'] as String?,
  nomeVendedor: json['nomeVendedor'] as String?,
  emailVendedor: json['emailVendedor'] as String?,
  valorTotal: (json['valorTotal'] as num?)?.toDouble(),
  idEstado: (json['idEstado'] as num).toInt(),
  designacaoEstado: json['designacaoEstado'] as String?,
  dataInsertEncomenda:
      json['dataInsertEncomenda'] == null
          ? null
          : DateTime.parse(json['dataInsertEncomenda'] as String),
  dataEntregaPrevista:
      json['dataEntregaPrevista'] == null
          ? null
          : DateTime.parse(json['dataEntregaPrevista'] as String),
  referenciaCliente: json['referenciaCliente'] as String?,
  observacoes: json['observacoes'] as String?,
);

Map<String, dynamic> _$EncomendaToJson(Encomenda instance) => <String, dynamic>{
  'idEncomenda': instance.idEncomenda,
  'idCliente': instance.idCliente,
  'nomeCliente': instance.nomeCliente,
  'codigoCliente': instance.codigoCliente,
  'codigoBarras': instance.codigoBarras,
  'nomeVendedor': instance.nomeVendedor,
  'emailVendedor': instance.emailVendedor,
  'valorTotal': instance.valorTotal,
  'idEstado': instance.idEstado,
  'designacaoEstado': instance.designacaoEstado,
  'dataInsertEncomenda': instance.dataInsertEncomenda?.toIso8601String(),
  'dataEntregaPrevista': instance.dataEntregaPrevista?.toIso8601String(),
  'referenciaCliente': instance.referenciaCliente,
  'observacoes': instance.observacoes,
};

EncomendaDetail _$EncomendaDetailFromJson(Map<String, dynamic> json) =>
    EncomendaDetail(
      idEncomenda: (json['idEncomenda'] as num).toInt(),
      idCliente: (json['idCliente'] as num).toInt(),
      nomeCliente: json['nomeCliente'] as String?,
      codigoCliente: json['codigoCliente'] as String?,
      nifCliente: json['nifCliente'] as String?,
      emailCliente: json['emailCliente'] as String?,
      telefoneCliente: json['telefoneCliente'] as String?,
      codigoBarras: json['codigoBarras'] as String?,
      usernameVendedor: json['usernameVendedor'] as String?,
      nomeVendedor: json['nomeVendedor'] as String?,
      emailVendedor: json['emailVendedor'] as String?,
      valorTotal: (json['valorTotal'] as num?)?.toDouble(),
      idEstado: (json['idEstado'] as num).toInt(),
      designacaoEstado: json['designacaoEstado'] as String?,
      dataInsertEncomenda:
          json['dataInsertEncomenda'] == null
              ? null
              : DateTime.parse(json['dataInsertEncomenda'] as String),
      dataEntregaPrevista:
          json['dataEntregaPrevista'] == null
              ? null
              : DateTime.parse(json['dataEntregaPrevista'] as String),
      enderecoEntrega1: json['enderecoEntrega1'] as String?,
      enderecoEntrega2: json['enderecoEntrega2'] as String?,
      enderecoEntrega3: json['enderecoEntrega3'] as String?,
      cpostalEntrega: json['cpostalEntrega'] as String?,
      nomeContacto: json['nomeContacto'] as String?,
      telefoneContacto: json['telefoneContacto'] as String?,
      referenciaCliente: json['referenciaCliente'] as String?,
      observacoes: json['observacoes'] as String?,
      detalhes:
          (json['detalhes'] as List<dynamic>?)
              ?.map((e) => EncomendaDetalhe.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$EncomendaDetailToJson(EncomendaDetail instance) =>
    <String, dynamic>{
      'idEncomenda': instance.idEncomenda,
      'idCliente': instance.idCliente,
      'nomeCliente': instance.nomeCliente,
      'codigoCliente': instance.codigoCliente,
      'nifCliente': instance.nifCliente,
      'emailCliente': instance.emailCliente,
      'telefoneCliente': instance.telefoneCliente,
      'codigoBarras': instance.codigoBarras,
      'usernameVendedor': instance.usernameVendedor,
      'nomeVendedor': instance.nomeVendedor,
      'emailVendedor': instance.emailVendedor,
      'valorTotal': instance.valorTotal,
      'idEstado': instance.idEstado,
      'designacaoEstado': instance.designacaoEstado,
      'dataInsertEncomenda': instance.dataInsertEncomenda?.toIso8601String(),
      'dataEntregaPrevista': instance.dataEntregaPrevista?.toIso8601String(),
      'enderecoEntrega1': instance.enderecoEntrega1,
      'enderecoEntrega2': instance.enderecoEntrega2,
      'enderecoEntrega3': instance.enderecoEntrega3,
      'cpostalEntrega': instance.cpostalEntrega,
      'nomeContacto': instance.nomeContacto,
      'telefoneContacto': instance.telefoneContacto,
      'referenciaCliente': instance.referenciaCliente,
      'observacoes': instance.observacoes,
      'detalhes': instance.detalhes,
    };

EncomendaDetalhe _$EncomendaDetalheFromJson(Map<String, dynamic> json) =>
    EncomendaDetalhe(
      idEncomendaDetalhe: (json['idEncomendaDetalhe'] as num?)?.toInt(),
      idEncomenda: (json['idEncomenda'] as num?)?.toInt(),
      idProduto: (json['idProduto'] as num).toInt(),
      codigoProduto: json['codigoProduto'] as String?,
      designacaoProduto: json['designacaoProduto'] as String?,
      idCor: (json['idCor'] as num).toInt(),
      codigoCor: json['codigoCor'] as String?,
      designacaoCor: json['designacaoCor'] as String?,
      idTamanho: (json['idTamanho'] as num).toInt(),
      codigoTamanho: json['codigoTamanho'] as String?,
      designacaoTamanho: json['designacaoTamanho'] as String?,
      quantidade: (json['quantidade'] as num).toInt(),
      preco: (json['preco'] as num).toDouble(),
      total: (json['total'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$EncomendaDetalheToJson(EncomendaDetalhe instance) =>
    <String, dynamic>{
      'idEncomendaDetalhe': instance.idEncomendaDetalhe,
      'idEncomenda': instance.idEncomenda,
      'idProduto': instance.idProduto,
      'codigoProduto': instance.codigoProduto,
      'designacaoProduto': instance.designacaoProduto,
      'idCor': instance.idCor,
      'codigoCor': instance.codigoCor,
      'designacaoCor': instance.designacaoCor,
      'idTamanho': instance.idTamanho,
      'codigoTamanho': instance.codigoTamanho,
      'designacaoTamanho': instance.designacaoTamanho,
      'quantidade': instance.quantidade,
      'preco': instance.preco,
      'total': instance.total,
    };

CreateEncomendaDto _$CreateEncomendaDtoFromJson(
  Map<String, dynamic> json,
) => CreateEncomendaDto(
  idCliente: (json['idCliente'] as num).toInt(),
  dataEntregaPrevista: DateTime.parse(json['dataEntregaPrevista'] as String),
  enderecoEntrega1: json['enderecoEntrega1'] as String?,
  enderecoEntrega2: json['enderecoEntrega2'] as String?,
  enderecoEntrega3: json['enderecoEntrega3'] as String?,
  cpostalEntrega: json['cpostalEntrega'] as String?,
  nomeContacto: json['nomeContacto'] as String?,
  telefoneContacto: json['telefoneContacto'] as String?,
  referenciaCliente: json['referenciaCliente'] as String?,
  observacoes: json['observacoes'] as String?,
  detalhes:
      (json['detalhes'] as List<dynamic>)
          .map(
            (e) =>
                CreateEncomendaDetalheDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$CreateEncomendaDtoToJson(CreateEncomendaDto instance) =>
    <String, dynamic>{
      'idCliente': instance.idCliente,
      'dataEntregaPrevista': instance.dataEntregaPrevista.toIso8601String(),
      'enderecoEntrega1': instance.enderecoEntrega1,
      'enderecoEntrega2': instance.enderecoEntrega2,
      'enderecoEntrega3': instance.enderecoEntrega3,
      'cpostalEntrega': instance.cpostalEntrega,
      'nomeContacto': instance.nomeContacto,
      'telefoneContacto': instance.telefoneContacto,
      'referenciaCliente': instance.referenciaCliente,
      'observacoes': instance.observacoes,
      'detalhes': instance.detalhes,
    };

CreateEncomendaDetalheDto _$CreateEncomendaDetalheDtoFromJson(
  Map<String, dynamic> json,
) => CreateEncomendaDetalheDto(
  idProduto: (json['idProduto'] as num).toInt(),
  idCor: (json['idCor'] as num).toInt(),
  idTamanho: (json['idTamanho'] as num).toInt(),
  quantidade: (json['quantidade'] as num).toInt(),
  preco: (json['preco'] as num).toDouble(),
);

Map<String, dynamic> _$CreateEncomendaDetalheDtoToJson(
  CreateEncomendaDetalheDto instance,
) => <String, dynamic>{
  'idProduto': instance.idProduto,
  'idCor': instance.idCor,
  'idTamanho': instance.idTamanho,
  'quantidade': instance.quantidade,
  'preco': instance.preco,
};
