import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/encomenda.dart';
import '../../data/models/estado.dart';
import '../../data/providers/estado_provider.dart';
import '../../data/providers/encomenda_provider.dart';
import '../../core/constants/ui_constants.dart';

class EncomendaCard extends ConsumerWidget {
  final Encomenda encomenda;
  final VoidCallback? onTap;

  const EncomendaCard({super.key, required this.encomenda, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estadosAsync = ref.watch(estadosListProvider);
    // ✅ Capturar ScaffoldMessenger ANTES de qualquer operação assíncrona
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: UIConstants.spacingM,
        vertical: UIConstants.spacingS,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========== CABEÇALHO ==========
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Número da encomenda
                  Text(
                    'Encomenda #${encomenda.idEncomenda}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  // Data
                  Text(
                    encomenda.dataInsertEncomenda != null
                        ? DateFormat('dd/MM/yyyy')
                            .format(encomenda.dataInsertEncomenda!)
                        : '-',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: UIConstants.spacingS),

              // ========== CLIENTE ==========
              if (encomenda.nomeCliente != null &&
                  encomenda.nomeCliente!.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: UIConstants.spacingS),
                    Expanded(
                      child: Text(
                        encomenda.nomeCliente!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: UIConstants.spacingS),
              ],

              // ========== DROPDOWN DE ESTADO ==========
              Row(
                children: [
                  const Icon(Icons.label, size: 16, color: Colors.grey),
                  const SizedBox(width: UIConstants.spacingS),
                  Expanded(
                    child: estadosAsync.when(
                      data: (estados) {
                        return _EstadoDropdown(
                          encomenda: encomenda,
                          estados: estados,
                          scaffoldMessenger: scaffoldMessenger, // ✅ Passar messenger
                          onEstadoChanged: (novoEstado) async {
                            // Atualizar estado da encomenda
                            await ref
                                .read(encomendaProvider.notifier)
                                .updateEstado(
                                  encomenda.idEncomenda,
                                  novoEstado.idEstado,
                                );

                            // Refresh da lista
                            ref.invalidate(encomendasListProvider);
                          },
                        );
                      },
                      loading: () => const Text('A carregar estados...'),
                      error: (_, __) {
                        final estado = encomenda.idEstado;
                        return Text(
                          estado != 0
                              ? 'Estado: $estado'
                              : 'Estado desconhecido',
                          style: Theme.of(context).textTheme.bodyMedium,
                        );
                      },
                    ),
                  ),
                ],
              ),

              // ========== OBSERVAÇÕES (se houver) ==========
              if (encomenda.observacoes != null &&
                  encomenda.observacoes!.isNotEmpty) ...[
                const SizedBox(height: UIConstants.spacingS),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.notes, size: 16, color: Colors.grey),
                    const SizedBox(width: UIConstants.spacingS),
                    Expanded(
                      child: Text(
                        encomenda.observacoes!,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget dropdown para alterar estado da encomenda
class _EstadoDropdown extends StatefulWidget {
  final Encomenda encomenda;
  final List<Estado> estados;
  final ScaffoldMessengerState scaffoldMessenger; // ✅ NOVO
  final Function(Estado) onEstadoChanged;

  const _EstadoDropdown({
    required this.encomenda,
    required this.estados,
    required this.scaffoldMessenger, // ✅ NOVO
    required this.onEstadoChanged,
  });

  @override
  State<_EstadoDropdown> createState() => _EstadoDropdownState();
}

class _EstadoDropdownState extends State<_EstadoDropdown> {
  bool _isUpdating = false;

  Color _getEstadoColor(int? idEstado) {
    switch (idEstado) {
      case 1: // Nova
        return Colors.blue;
      case 2: // Em Produção
        return Colors.orange;
      case 3: // Concluída
        return Colors.green;
      case 4: // Cancelada
        return Colors.red;
      case 5: // Pausada
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentEstado = widget.encomenda.idEstado;
    final estadoColor = _getEstadoColor(currentEstado);

    if (_isUpdating) {
      return Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: estadoColor,
            ),
          ),
          const SizedBox(width: 8),
          const Text('A atualizar...'),
        ],
      );
    }

    return DropdownButton<Estado>(
      value: widget.estados.firstWhere(
        (e) => e.idEstado == currentEstado,
        orElse: () => widget.estados.first,
      ),
      isExpanded: true,
      underline: Container(
        height: 1,
        color: estadoColor.withValues(alpha: 0.3),
      ),
      icon: Icon(Icons.arrow_drop_down, color: estadoColor),
      style: TextStyle(color: estadoColor, fontWeight: FontWeight.w600),
      items: widget.estados.map((Estado estado) {
        final color = _getEstadoColor(estado.idEstado);
        return DropdownMenuItem<Estado>(
          value: estado,
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(estado.designacaoEstado, style: TextStyle(color: color)),
            ],
          ),
        );
      }).toList(),
      onChanged: (Estado? novoEstado) async {
        if (novoEstado != null && novoEstado.idEstado != currentEstado) {
          // Confirmar mudança de estado
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Alterar Estado'),
              content: Text(
                'Deseja alterar o estado da encomenda #${widget.encomenda.idEncomenda} para "${novoEstado.designacaoEstado}"?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Confirmar'),
                ),
              ],
            ),
          );

          if (confirmed == true && mounted) {
            setState(() => _isUpdating = true);

            try {
              await widget.onEstadoChanged(novoEstado);

              // ✅ Usar scaffoldMessenger capturado no build
              if (mounted) {
                widget.scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      'Estado alterado para "${novoEstado.designacaoEstado}"',
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            } catch (e) {
              // ✅ Usar scaffoldMessenger capturado no build
              if (mounted) {
                widget.scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Erro ao alterar estado: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } finally {
              if (mounted) {
                setState(() => _isUpdating = false);
              }
            }
          }
        }
      },
    );
  }
}
