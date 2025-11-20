import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';
import '../models/estado.dart';

class EstadoRepository {
  final ApiService _apiService;

  EstadoRepository(this._apiService);

  /// Buscar todos os estados de encomenda
  Future<List<Estado>> getEstados() async {
    try {
      final response = await _apiService.get(ApiConstants.estadosEndpoint);

      if (response.data is List) {
        return (response.data as List)
            .map((json) => Estado.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Formato de resposta inválido');
    } catch (e) {
      throw Exception('Erro ao buscar estados: $e');
    }
  }
}
