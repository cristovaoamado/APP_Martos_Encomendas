import 'package:encomendas_app/data/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/models/cor.dart';
import '../../data/repositories/produto_repository.dart';

/// Provider para cores de um produto específico
final coresProdutoProvider = FutureProvider.family<List<Cor>, int>((ref, idProduto) async {
  final repository = ref.read(produtoRepositoryProvider);
  return await repository.getCoresProduto(idProduto);
});

/// State notifier para gerenciar produto e cores selecionados
class ProdutoCorState {
  final int? idProduto;
  final List<Cor> coresDisponiveis;
  final int? idCorSelecionada;

  ProdutoCorState({
    this.idProduto,
    this.coresDisponiveis = const [],
    this.idCorSelecionada,
  });

  ProdutoCorState copyWith({
    int? idProduto,
    List<Cor>? coresDisponiveis,
    int? idCorSelecionada,
  }) {
    return ProdutoCorState(
      idProduto: idProduto ?? this.idProduto,
      coresDisponiveis: coresDisponiveis ?? this.coresDisponiveis,
      idCorSelecionada: idCorSelecionada ?? this.idCorSelecionada,
    );
  }
}

class ProdutoCorNotifier extends StateNotifier<ProdutoCorState> {
  final ProdutoRepository _repository;

  ProdutoCorNotifier(this._repository) : super(ProdutoCorState());

  Future<void> carregarCoresProduto(int idProduto) async {
    try {
      final cores = await _repository.getCoresProduto(idProduto);
      state = state.copyWith(
        idProduto: idProduto,
        coresDisponiveis: cores,
        idCorSelecionada: null,
      );
    } catch (e) {
      // Tratar erro
      rethrow;
    }
  }

  void selecionarCor(int idCor) {
    state = state.copyWith(idCorSelecionada: idCor);
  }

  void limpar() {
    state = ProdutoCorState();
  }
}

final produtoCorProvider = StateNotifierProvider<ProdutoCorNotifier, ProdutoCorState>((ref) {
  final repository = ref.read(produtoRepositoryProvider);
  return ProdutoCorNotifier(repository);
});
