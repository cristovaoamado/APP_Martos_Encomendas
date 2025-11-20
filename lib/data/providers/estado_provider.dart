import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/estado_repository.dart';
import '../models/estado.dart';
import 'providers.dart';

// Repository Provider
final estadoRepositoryProvider = Provider<EstadoRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return EstadoRepository(apiService);
});

// Provider para lista de estados (cacheable)
final estadosListProvider = FutureProvider<List<Estado>>((ref) async {
  final repository = ref.watch(estadoRepositoryProvider);
  return await repository.getEstados();
});
