import '../models/encomenda.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class EncomendaRepository {
  final ApiService _apiService;

  EncomendaRepository(this._apiService);

  /// Listar encomendas com filtros
  Future<List<Encomenda>> getEncomendas({
    int? idCliente,
    int? idEstado,
    String? searchTerm,
    int page = 1,
    int pageSize = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
    };

    if (idCliente != null) queryParams['idCliente'] = idCliente;
    if (idEstado != null) queryParams['idEstado'] = idEstado;
    if (searchTerm != null && searchTerm.isNotEmpty) {
      queryParams['searchTerm'] = searchTerm;
    }

    final response = await _apiService.get(
      ApiConstants.encomendasEndpoint,
      queryParameters: queryParams,
    );

    final List<dynamic> data = response.data as List;
    return data.map((json) => Encomenda.fromJson(json)).toList();
  }

  /// Obter detalhes de uma encomenda
  Future<EncomendaDetail> getEncomendaById(int id) async {
    final response = await _apiService.get(
      '${ApiConstants.encomendasEndpoint}/$id',
    );

    return EncomendaDetail.fromJson(response.data);
  }

  /// Criar nova encomenda
  Future<EncomendaDetail> createEncomenda(CreateEncomendaDto dto) async {
    final response = await _apiService.post(
      ApiConstants.encomendasEndpoint,
      data: dto.toJson(),
    );

    return EncomendaDetail.fromJson(response.data);
  }

  /// ✅ ATUALIZADO - Atualizar estado da encomenda
  Future<void> updateEstado(int id, int novoEstado) async {
    try {
      await _apiService.put(
        '${ApiConstants.encomendasEndpoint}/$id/estado',
        data: {'idEstado': novoEstado},
      );
    } catch (e) {
      throw Exception('Erro ao atualizar estado da encomenda: $e');
    }
  }

  /// Obter encomendas de um cliente
  Future<List<Encomenda>> getEncomendasByCliente(int idCliente) async {
    final response = await _apiService.get(
      '${ApiConstants.encomendasEndpoint}/cliente/$idCliente',
    );

    final List<dynamic> data = response.data as List;
    return data.map((json) => Encomenda.fromJson(json)).toList();
  }

  /// Obter encomendas em produção
  Future<List<Encomenda>> getEncomendasEmProducao() async {
    final response = await _apiService.get(
      '${ApiConstants.encomendasEndpoint}/producao',
    );

    final List<dynamic> data = response.data as List;
    return data.map((json) => Encomenda.fromJson(json)).toList();
  }

  /// Obter detalhes/itens de uma encomenda
  Future<List<EncomendaDetalhe>> getEncomendaDetalhes(int id) async {
    final response = await _apiService.get(
      '${ApiConstants.encomendasEndpoint}/$id/detalhes',
    );

    final List<dynamic> data = response.data as List;
    return data.map((json) => EncomendaDetalhe.fromJson(json)).toList();
  }
}
