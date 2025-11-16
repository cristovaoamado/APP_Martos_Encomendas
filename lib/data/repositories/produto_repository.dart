import '../models/produto.dart';
import '../models/cor.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class ProdutoRepository {
  final ApiService _apiService;

  ProdutoRepository(this._apiService);

  /// Obter lista de produtos
  Future<List<Produto>> getProdutos({bool? ativo, String? searchTerm}) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (ativo != null) {
        queryParams['ativo'] = ativo.toString();
      }
      
      if (searchTerm != null && searchTerm.isNotEmpty) {
        queryParams['searchTerm'] = searchTerm;
      }

      final queryString = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');

      final url = queryString.isEmpty
          ? ApiConstants.produtosEndpoint
          : '${ApiConstants.produtosEndpoint}?$queryString';

      final response = await _apiService.get(url);

      final List<dynamic> data = response.data;
      return data.map((json) => Produto.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar produtos: $e');
    }
  }

  /// Pesquisar produtos (usado no autocomplete)
  Future<List<Produto>> searchProdutos(String query) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.produtosEndpoint}?searchTerm=$query&ativo=true',
      );

      final List<dynamic> data = response.data;
      return data.map((json) => Produto.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao pesquisar produtos: $e');
    }
  }

  /// Obter produto por ID
  Future<Produto> getProdutoById(int id) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.produtosEndpoint}/$id',
      );

      return Produto.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao buscar produto: $e');
    }
  }

  /// Obter cores disponíveis para um produto (do cartaz)
  Future<List<Cor>> getCoresProduto(int idProduto) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.produtosEndpoint}/$idProduto/cores',
      );

      final List<dynamic> data = response.data;
      return data.map((json) => Cor.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar cores do produto: $e');
    }
  }
}
