import 'package:encomendas_app/data/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/produto.dart';
import '../../data/repositories/produto_repository.dart';

/// Provider para o repositório de produtos
final produtoRepositoryProvider = Provider<ProdutoRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ProdutoRepository(apiService);
});

/// Provider para lista de produtos ativos
final produtosAtivosProvider = FutureProvider<List<Produto>>((ref) async {
  final repository = ref.read(produtoRepositoryProvider);
  return await repository.getProdutos(ativo: true);
});

/// Provider para pesquisar produtos
final produtoSearchProvider = FutureProvider.family<List<Produto>, String>((ref, query) async {
  if (query.length < 3) {
    return [];
  }
  final repository = ref.read(produtoRepositoryProvider);
  return await repository.searchProdutos(query);
});
