import 'package:encomendas_app/data/repositories/encomenda_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/encomenda.dart';
import 'providers.dart';

// ============================================
// PROVIDERS PARA LISTAGENS
// ============================================

// Provider para lista de encomendas
final encomendasListProvider = FutureProvider.autoDispose
    .family<List<Encomenda>, EncomendaFilters>((ref, filters) async {
  final repository = ref.watch(encomendaRepositoryProvider);

  return repository.getEncomendas(
    idCliente: filters.idCliente,
    idEstado: filters.idEstado,
    searchTerm: filters.searchTerm,
    page: filters.page,
    pageSize: filters.pageSize,
  );
});

// Provider para detalhes de encomenda
final encomendaDetailProvider = FutureProvider.autoDispose
    .family<EncomendaDetail, int>((ref, id) async {
  final repository = ref.watch(encomendaRepositoryProvider);
  return repository.getEncomendaById(id);
});

// Provider para encomendas em produção
final encomendasProducaoProvider =
    FutureProvider.autoDispose<List<Encomenda>>((ref) async {
  final repository = ref.watch(encomendaRepositoryProvider);
  return repository.getEncomendasEmProducao();
});

// ============================================
// STATE NOTIFIER PARA OPERAÇÕES
// ============================================

/// ✅ NOVO - StateNotifier para operações de encomenda
class EncomendaNotifier extends StateNotifier<AsyncValue<EncomendaDetail?>> {
  final EncomendaRepository _repository;

  EncomendaNotifier(this._repository) : super(const AsyncValue.data(null));

  /// Carregar encomenda específica
  Future<void> loadEncomenda(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getEncomendaById(id));
  }

  /// ✅ NOVO - Atualizar estado de uma encomenda
  Future<void> updateEstado(int idEncomenda, int novoIdEstado) async {
    try {
      await _repository.updateEstado(idEncomenda, novoIdEstado);

      // Se a encomenda atual está carregada e é a mesma, recarregar
      if (state is AsyncData<EncomendaDetail?>) {
        final encomenda = state.value;
        if (encomenda != null && encomenda.idEncomenda == idEncomenda) {
          await loadEncomenda(idEncomenda);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Criar nova encomenda
  Future<EncomendaDetail> createEncomenda(CreateEncomendaDto dto) async {
    try {
      final encomenda = await _repository.createEncomenda(dto);
      state = AsyncValue.data(encomenda);
      return encomenda;
    } catch (e) {
      rethrow;
    }
  }
}

/// ✅ NOVO - Provider para EncomendaNotifier
final encomendaProvider =
    StateNotifierProvider<EncomendaNotifier, AsyncValue<EncomendaDetail?>>(
  (ref) {
    final repository = ref.watch(encomendaRepositoryProvider);
    return EncomendaNotifier(repository);
  },
);

// Provider para criar encomenda (mantido para compatibilidade)
final createEncomendaProvider = Provider<EncomendaRepository>((ref) {
  return ref.watch(encomendaRepositoryProvider);
});

// ============================================
// CLASSE DE FILTROS
// ============================================

/// Classe para filtros
// ========== ADICIONAR/SUBSTITUIR a classe EncomendaFilters ==========

/// Classe para filtros
class EncomendaFilters {
  final int? idCliente;
  final int? idEstado;
  final String? searchTerm;
  final int page;
  final int pageSize;

  EncomendaFilters({
    this.idCliente,
    this.idEstado,
    this.searchTerm,
    this.page = 1,
    this.pageSize = 20,
  });

  /// ✅ CORRIGIDO: copyWith que permite passar null explicitamente
  EncomendaFilters copyWith({
    int? Function()? idCliente,
    int? Function()? idEstado,
    String? Function()? searchTerm,
    int? page,
    int? pageSize,
  }) {
    return EncomendaFilters(
      idCliente: idCliente != null ? idCliente() : this.idCliente,
      idEstado: idEstado != null ? idEstado() : this.idEstado,
      searchTerm: searchTerm != null ? searchTerm() : this.searchTerm,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EncomendaFilters &&
        other.idCliente == idCliente &&
        other.idEstado == idEstado &&
        other.searchTerm == searchTerm &&
        other.page == page &&
        other.pageSize == pageSize;
  }

  @override
  int get hashCode {
    return idCliente.hashCode ^
        idEstado.hashCode ^
        searchTerm.hashCode ^
        page.hashCode ^
        pageSize.hashCode;
  }

  @override
  String toString() {
    return 'EncomendaFilters(idCliente: $idCliente, idEstado: $idEstado, searchTerm: $searchTerm, page: $page, pageSize: $pageSize)';
  }
}
