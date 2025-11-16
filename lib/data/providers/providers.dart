import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../repositories/auth_repository.dart';
import '../repositories/encomenda_repository.dart';
import '../repositories/cliente_repository.dart';
import '../repositories/produto_repository.dart';
import '../repositories/cor_repository.dart';
import '../repositories/tamanho_repository.dart';

// Storage Service Provider
// Este provider será sobrescrito no main.dart com a instância real
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError(
    'StorageService deve ser inicializado no main.dart com SharedPreferences'
  );
});

// API Service Provider
final apiServiceProvider = Provider<ApiService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ApiService(storageService);
});

// Repository Providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final storageService = ref.watch(storageServiceProvider);
  return AuthRepository(apiService, storageService);
});

final encomendaRepositoryProvider = Provider<EncomendaRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return EncomendaRepository(apiService);
});

final clienteRepositoryProvider = Provider<ClienteRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ClienteRepository(apiService);
});

final produtoRepositoryProvider = Provider<ProdutoRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ProdutoRepository(apiService);
});

final corRepositoryProvider = Provider<CorRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CorRepository(apiService);
});

final tamanhoRepositoryProvider = Provider<TamanhoRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return TamanhoRepository(apiService);
});
