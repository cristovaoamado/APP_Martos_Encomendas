import '../models/tamanho.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class TamanhoRepository {
  final ApiService _apiService;

  TamanhoRepository(this._apiService);

  /// Listar todos os tamanhos ativos
  Future<List<Tamanho>> getTamanhos({
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
      ApiConstants.tamanhosEndpoint,
      queryParameters: queryParams,
    );

    final List<dynamic> data = response.data as List;
    return data.map((json) => Tamanho.fromJson(json)).toList();
  }

  /// Obter tamanho por ID
  Future<Tamanho> getTamanhoById(int id) async {
    final response = await _apiService.get(
      '${ApiConstants.tamanhosEndpoint}/$id',
    );

    return Tamanho.fromJson(response.data);
  }
}
