import '../models/cor.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class CorRepository {
  final ApiService _apiService;

  CorRepository(this._apiService);

  /// Listar todas as cores ativas
  Future<List<Cor>> getCores({
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
      ApiConstants.coresEndpoint,
      queryParameters: queryParams,
    );

    final List<dynamic> data = response.data as List;
    return data.map((json) => Cor.fromJson(json)).toList();
  }

  /// Obter cor por ID
  Future<Cor> getCorById(int id) async {
    final response = await _apiService.get(
      '${ApiConstants.coresEndpoint}/$id',
    );

    return Cor.fromJson(response.data);
  }

  /// Obter cores por cartaz
  Future<List<Cor>> getCoresByCartaz(int idCartaz) async {
    final response = await _apiService.get(
      '${ApiConstants.coresEndpoint}/cartaz/$idCartaz',
    );

    final List<dynamic> data = response.data as List;
    return data.map((json) => Cor.fromJson(json)).toList();
  }
}
