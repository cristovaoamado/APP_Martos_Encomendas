import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cliente.dart';
import '../models/produto.dart';
import '../models/cor.dart';
import '../models/tamanho.dart';
import 'providers.dart';

// ============= CLIENTES =============

final clientesListProvider = FutureProvider.autoDispose<List<Cliente>>((
  ref,
) async {
  if (kDebugMode) {
    print('═══════════════════════════════════════════════════');
    print('🌐 CARREGANDO CLIENTES...');
  }

  final repository = ref.watch(clienteRepositoryProvider);
  final clientes = await repository.getClientes(ativo: true);

  if (kDebugMode) {
    print('✅ Recebidos ${clientes.length} clientes');
  }

  if (clientes.isNotEmpty) {
    final primeiro = clientes.first;
    if (kDebugMode) {
      print('─────────────────────────────────────────────────');
      print('🔍 PRIMEIRO CLIENTE:');
      print('  idCliente: ${primeiro.idCliente}');
      print('  nomeCliente: "${primeiro.nomeCliente}"');
      print('  ruaCliente: "${primeiro.ruaCliente}"');
      print('  localidadeCliente: "${primeiro.localidadeCliente}"');
      print('  cpostalCliente: "${primeiro.cpostalCliente}"');
      print('  nomeContactoCliente: "${primeiro.nomeContactoCliente}"');
      print('  telefoneContactoCliente: "${primeiro.telefoneContactoCliente}"');
      print('  telefoneCliente: "${primeiro.telefoneCliente}"');
      print('─────────────────────────────────────────────────');
    }

    // Verificar se campos estão vazios ou null
    if (primeiro.ruaCliente == null || primeiro.ruaCliente!.isEmpty) {
      if (kDebugMode) {
        print('⚠️ ATENÇÃO: ruaCliente está vazio ou null!');
      }
    }
    if (primeiro.localidadeCliente == null ||
        primeiro.localidadeCliente!.isEmpty) {
      if (kDebugMode) {
        print('⚠️ ATENÇÃO: localidadeCliente está vazio ou null!');
      }
    }
    if (primeiro.cpostalCliente == null || primeiro.cpostalCliente!.isEmpty) {
      if (kDebugMode) {
        print('⚠️ ATENÇÃO: cpostalCliente está vazio ou null!');
      }
    }
  }

  if (kDebugMode) {
    print('═══════════════════════════════════════════════════');
  }

  return clientes;
});

final clienteByIdProvider = FutureProvider.autoDispose.family<Cliente, int>((
  ref,
  id,
) async {
  if (kDebugMode) {
    print('🔍 Buscando cliente ID: $id');
  }

  final repository = ref.watch(clienteRepositoryProvider);
  final cliente = await repository.getClienteById(id);

  if (kDebugMode) {
    print('📦 Cliente carregado:');
    print('  nomeCliente: "${cliente.nomeCliente}"');
    print('  ruaCliente: "${cliente.ruaCliente}"');
    print('  localidadeCliente: "${cliente.localidadeCliente}"');
    print('  cpostalCliente: "${cliente.cpostalCliente}"');
  }

  return cliente;
});

final searchClientesProvider = FutureProvider.autoDispose
    .family<List<Cliente>, String>((ref, query) async {
      final repository = ref.watch(clienteRepositoryProvider);
      return repository.searchClientes(query);
    });

// ============= PRODUTOS =============

final produtosListProvider = FutureProvider.autoDispose<List<Produto>>((
  ref,
) async {
  final repository = ref.watch(produtoRepositoryProvider);
  return repository.getProdutos(ativo: true);
});

final produtoByIdProvider = FutureProvider.autoDispose.family<Produto, int>((
  ref,
  id,
) async {
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
      return repository.getCoresProduto(idProduto);
    });

// ============= CORES =============

final coresListProvider = FutureProvider.autoDispose<List<Cor>>((ref) async {
  final repository = ref.watch(corRepositoryProvider);
  return repository.getCores(ativo: true);
});

final corByIdProvider = FutureProvider.autoDispose.family<Cor, int>((
  ref,
  id,
) async {
  final repository = ref.watch(corRepositoryProvider);
  return repository.getCorById(id);
});

final coresByCartazProvider = FutureProvider.autoDispose.family<List<Cor>, int>(
  (ref, idCartaz) async {
    final repository = ref.watch(corRepositoryProvider);
    return repository.getCoresByCartaz(idCartaz);
  },
);

// ============= TAMANHOS =============

final tamanhosListProvider = FutureProvider.autoDispose<List<Tamanho>>((
  ref,
) async {
  final repository = ref.watch(tamanhoRepositoryProvider);
  return repository.getTamanhos(ativo: true);
});

final tamanhoByIdProvider = FutureProvider.autoDispose.family<Tamanho, int>((
  ref,
  id,
) async {
  final repository = ref.watch(tamanhoRepositoryProvider);
  return repository.getTamanhoById(id);
});
