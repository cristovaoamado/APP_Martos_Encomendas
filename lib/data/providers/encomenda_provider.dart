import 'package:encomendas_app/data/repositories/encomenda_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/encomenda.dart';
import 'providers.dart';

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
final encomendasProducaoProvider = FutureProvider.autoDispose<List<Encomenda>>((ref) async {
  final repository = ref.watch(encomendaRepositoryProvider);
  return repository.getEncomendasEmProducao();
});

// Provider para criar encomenda
final createEncomendaProvider = Provider<EncomendaRepository>((ref) {
  return ref.watch(encomendaRepositoryProvider);
});

// Classe para filtros
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

  EncomendaFilters copyWith({
    int? idCliente,
    int? idEstado,
    String? searchTerm,
    int? page,
    int? pageSize,
  }) {
    return EncomendaFilters(
      idCliente: idCliente ?? this.idCliente,
      idEstado: idEstado ?? this.idEstado,
      searchTerm: searchTerm ?? this.searchTerm,
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
}
