import '../models/cliente.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class ClienteRepository {
  final ApiService _apiService;

  ClienteRepository(this._apiService);

  /// Listar todos os clientes ativos
  Future<List<Cliente>> getClientes({
    String? searchTerm,
    bool? ativo,
  }) async {
    final queryParams = <String, dynamic>{};

    if (searchTerm != null && searchTerm.isNotEmpty) {
      queryParams['searchTerm'] = searchTerm;
    }
    if (ativo != null) {
      queryParams['ativo'] = ativo;
    }

    final response = await _apiService.get(
      ApiConstants.clientesEndpoint,
      queryParameters: queryParams,
    );

    final List<dynamic> data = response.data as List;
    return data.map((json) => Cliente.fromJson(json)).toList();
  }

  /// Obter cliente por ID
  Future<Cliente> getClienteById(int id) async {
    final response = await _apiService.get(
      '${ApiConstants.clientesEndpoint}/$id',
    );

    return Cliente.fromJson(response.data);
  }

  /// Pesquisar clientes
  Future<List<Cliente>> searchClientes(String query) async {
    return getClientes(searchTerm: query, ativo: true);
  }
}
