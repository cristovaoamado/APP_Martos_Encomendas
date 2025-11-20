import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cliente.dart';
import '../models/produto.dart';
import '../models/cor.dart';
import '../models/tamanho.dart';
import 'providers.dart';

// ============= CLIENTES =============

final clientesListProvider = FutureProvider.autoDispose<List<Cliente>>((ref) async {
  final repository = ref.watch(clienteRepositoryProvider);
  return repository.getClientes(ativo: true);
});

final clienteByIdProvider = FutureProvider.autoDispose
    .family<Cliente, int>((ref, id) async {
  final repository = ref.watch(clienteRepositoryProvider);
  return repository.getClienteById(id);
});

final searchClientesProvider = FutureProvider.autoDispose
    .family<List<Cliente>, String>((ref, query) async {
  final repository = ref.watch(clienteRepositoryProvider);
  return repository.searchClientes(query);
});

// ============= PRODUTOS =============

final produtosListProvider = FutureProvider.autoDispose<List<Produto>>((ref) async {
  final repository = ref.watch(produtoRepositoryProvider);
  return repository.getProdutos(ativo: true);
});

final produtoByIdProvider = FutureProvider.autoDispose
    .family<Produto, int>((ref, id) async {
  final repository = ref.watch(produtoRepositoryProvider);
  return repository.getProdutoById(id);
});

final searchProdutosProvider = FutureProvider.autoDispose
    .family<List<Produto>, String>((ref, query) async {
  final repository = ref.watch(produtoRepositoryProvider);
  return repository.searchProdutos(query);
});

final coresByProdutoProvider = FutureProvider.autoDispose
    .family<List<Cor>, int>((ref, idProduto) async {
  final repository = ref.watch(produtoRepositoryProvider);
  return repository.getCoresProduto(idProduto); // ← CORRIGIDO: era getCoresByProduto
});

// ============= CORES =============

final coresListProvider = FutureProvider.autoDispose<List<Cor>>((ref) async {
  final repository = ref.watch(corRepositoryProvider);
  return repository.getCores(ativo: true);
});

final corByIdProvider = FutureProvider.autoDispose
    .family<Cor, int>((ref, id) async {
  final repository = ref.watch(corRepositoryProvider);
  return repository.getCorById(id);
});

final coresByCartazProvider = FutureProvider.autoDispose
    .family<List<Cor>, int>((ref, idCartaz) async {
  final repository = ref.watch(corRepositoryProvider);
  return repository.getCoresByCartaz(idCartaz);
});

// ============= TAMANHOS =============

final tamanhosListProvider = FutureProvider.autoDispose<List<Tamanho>>((ref) async {
  final repository = ref.watch(tamanhoRepositoryProvider);
  return repository.getTamanhos(ativo: true);
});

final tamanhoByIdProvider = FutureProvider.autoDispose
    .family<Tamanho, int>((ref, id) async {
  final repository = ref.watch(tamanhoRepositoryProvider);
  return repository.getTamanhoById(id);
});
