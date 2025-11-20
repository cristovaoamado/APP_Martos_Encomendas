import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/encomenda_provider.dart';
import '../../../data/providers/estado_provider.dart';
import '../../../core/constants/ui_constants.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart' as custom;
import '../../widgets/empty_state_widget.dart';
import '../../widgets/encomenda_card.dart';
import 'encomenda_detail_screen.dart';

class EncomendasListScreen extends ConsumerStatefulWidget {
  const EncomendasListScreen({super.key});

  @override
  ConsumerState<EncomendasListScreen> createState() =>
      _EncomendasListScreenState();
}

class _EncomendasListScreenState extends ConsumerState<EncomendasListScreen> {
  EncomendaFilters _filters = EncomendaFilters();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilters(EncomendaFilters newFilters) {
    setState(() {
      _filters = newFilters;
    });
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _FilterBottomSheet(
        currentFilters: _filters,
        onApply: _updateFilters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final encomendasAsync = ref.watch(encomendasListProvider(_filters));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Encomendas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(encomendasListProvider(_filters));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de pesquisa
          Padding(
            padding: const EdgeInsets.all(UIConstants.spacingM),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar encomendas...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _updateFilters(
                            _filters.copyWith(
                              searchTerm: () => null, // ✅ Usar função
                            ),
                          );
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                // Debounce search
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (_searchController.text == value) {
                    _updateFilters(
                      _filters.copyWith(
                        searchTerm: () => value.isEmpty ? null : value,
                      ),
                    );
                  }
                });
              },
            ),
          ),

          // Lista de encomendas
          Expanded(
            child: encomendasAsync.when(
              data: (encomendas) {
                if (encomendas.isEmpty) {
                  return const EmptyStateWidget(
                    message: 'Nenhuma encomenda encontrada',
                    icon: Icons.inbox,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(encomendasListProvider(_filters));
                  },
                  child: ListView.builder(
                    itemCount: encomendas.length,
                    itemBuilder: (context, index) {
                      final encomenda = encomendas[index];
                      return EncomendaCard(
                        encomenda: encomenda,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EncomendaDetailScreen(
                                idEncomenda: encomenda.idEncomenda,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
              loading: () =>
                  const LoadingWidget(message: 'A carregar encomendas...'),
              error: (error, stack) => custom.ErrorWidget(
                message: error.toString().replaceAll('Exception: ', ''),
                onRetry: () {
                  ref.invalidate(encomendasListProvider(_filters));
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/encomenda/create');
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova Encomenda'),
      ),
    );
  }
}

class _FilterBottomSheet extends ConsumerStatefulWidget {
  final EncomendaFilters currentFilters;
  final Function(EncomendaFilters) onApply;

  const _FilterBottomSheet({
    required this.currentFilters,
    required this.onApply,
  });

  @override
  ConsumerState<_FilterBottomSheet> createState() =>
      _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<_FilterBottomSheet> {
  late int? _selectedEstado;

  @override
  void initState() {
    super.initState();
    _selectedEstado = widget.currentFilters.idEstado;
  }

  Color _getEstadoColor(int? idEstado) {
    switch (idEstado) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      case 4:
        return Colors.red;
      case 5:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final estadosAsync = ref.watch(estadosListProvider);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Filtros',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: UIConstants.spacingL),

            // Filtro por estado
            Text(
              'Estado',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: UIConstants.spacingS),

            // ✅ Estados dinâmicos da API
            estadosAsync.when(
              data: (estados) {
                return Wrap(
                  spacing: UIConstants.spacingS,
                  runSpacing: UIConstants.spacingS,
                  children: [
                    // Chip "Todos"
                    FilterChip(
                      label: const Text('Todos'),
                      selected: _selectedEstado == null,
                      onSelected: (selected) {
                        setState(() {
                          _selectedEstado = null; // ✅ Explicitamente null
                        });
                      },
                    ),
                    // Chips dinâmicos para cada estado
                    ...estados.map((estado) {
                      final color = _getEstadoColor(estado.idEstado);
                      return FilterChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(estado.designacaoEstado),
                          ],
                        ),
                        selected: _selectedEstado == estado.idEstado,
                        selectedColor: color.withValues(alpha: 0.2),
                        onSelected: (selected) {
                          setState(() {
                            _selectedEstado =
                                selected ? estado.idEstado : null;
                          });
                        },
                      );
                    }),
                  ],
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => Text(
                'Erro ao carregar estados: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ),

            const SizedBox(height: UIConstants.spacingXL),

            // Botões
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: UIConstants.spacingM),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // ✅ CORRIGIDO: Usar função para passar null explicitamente
                      final newFilters = widget.currentFilters.copyWith(
                        idEstado: () => _selectedEstado,
                      );
                      widget.onApply(newFilters);
                      Navigator.pop(context);
                    },
                    child: const Text('Aplicar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
